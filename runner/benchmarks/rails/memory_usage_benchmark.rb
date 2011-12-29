require File.expand_path("../benchmark_helper.rb", __FILE__)
include BenchmarkHelper

ensure_database
ensure_server_not_running

IO.popen("bash", "w") do |bash|
  # jruby doesn't have fork...
  start_production_server(bash)

  if server_working?
    sample_count    = 30
    sample_duration = 15
    pid             = server_pid

    # put load on the web server....
    bash.puts "ab -t #{sample_duration*2 + 2} localhost:3009/ &"
    sleep 2

    # take some samples
    @memory_usage_bytes = (1..sample_count).map do 
      sleep(sample_duration.to_f / sample_count)
      `ps -o rss -p #{pid}`[/\d+\s*$/].to_i * 1024
    end.inject(0) { |sum, bytes| sum + bytes } / sample_count

    # stop apache bench
    bash.puts("kill -9 %2")
    @success = true
  else
    @success = false
  end

  kill_server
end

if @success
  puts "#{@memory_usage_bytes.to_f / 1024 / 1024} MB"
  exit(0)
else
  exit(1)
end