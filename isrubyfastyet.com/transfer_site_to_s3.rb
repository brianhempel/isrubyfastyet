require 'zlib'
require 'net/http'
require 'uri'
require 'yaml'
require 'aws-sdk'

S3_CREDENTIALS_PATH   = File.join(Dir.pwd, 's3_credentials-private.yml')
FIND_URLS_SCRIPT_PATH = File.join(Dir.pwd, 'find_urls.js')
SERVER_PORT           = 3011
SERVER_URL            = "http://localhost:#{SERVER_PORT}/"

puts "Transfering site to S3"



#################################################
###   1.  P R E C O M P I L E   a s s e t s   ###
#################################################

system('bundle exec rake -t assets:precompile') || exit(1)



###############################################
###   2.  S T A R T   t h e   s e r v e r   ###
###############################################

puts "Starting server"

server_pid = spawn("ruby script/rails s -e production -p #{SERVER_PORT}")

at_exit do
  puts "Shutting down server"
  Process.kill("INT", server_pid)
  Process.wait
end

def server_running?
  `curl #{SERVER_URL} 2> /dev/null`.size > 0
end

timeout_start = Time.now
sleep 0.2 until server_running? || (Time.now - timeout_start > 20)

unless server_running?
  STDERR.puts "Server failed to start!"
  exit(1)
end



#########################################################################
###   3.  D O W N L O A D   t h e   s i t e   i n t o   m e m o r y   ###
#########################################################################

urls = `phantomjs #{FIND_URLS_SCRIPT_PATH} #{SERVER_URL}`.lines

paths_and_responses = urls.map do |url|
  next unless url =~/^http/
  puts "Downloading #{url}"
  uri = URI.parse(url)
  output_path = uri.request_uri.gsub(/\/$/, '/index.html').gsub(/^\//, '')

  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)

  response = http.request(request)

  if response.code != "200"
    STDERR.puts "#{response.code} #{response.code_type} -- #{uri.request_uri}"
    exit 1
  end

  [output_path, response]
end



##########################################################
###   4.  U P L O A D   t h e    s i t e   t o   S 3   ###
##########################################################

s3_credentials = YAML.load(File.read(S3_CREDENTIALS_PATH))
s3             = AWS::S3.new(:access_key_id     => s3_credentials['access_key_id'],
                             :secret_access_key => s3_credentials['secret_access_key'])

bucket         = s3.buckets['www.isrubyfastyet.com']

paths_and_responses.each do |output_path, response|
  puts "Uploading #{output_path}"

  io = StringIO.new("w")
  gzipper = Zlib::GzipWriter.new(io, Zlib::BEST_COMPRESSION)
  gzipper.write(response.body)
  gzipper.close
  gzipped = io.string

  options = {
    :content_encoding   => 'gzip',
    :acl                => :public_read,
    :content_type       => response['content-type'],
    :reduced_redundancy => true,
  }
  options[:cache_control] = response['cache-control'] if response['cache-control']
  options[:expires]       = response['expires']       if response['expires']

  object = bucket.objects[output_path].write(gzipped, options)
end



###############################
###   4.  C L E A N   U P   ###
###############################

system('bundle exec rake -t assets:clean') || exit(1)
