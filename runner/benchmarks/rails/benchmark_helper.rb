require 'fileutils'

module BenchmarkHelper
  def db_path(file)
    File.expand_path("../db/#{file}", __FILE__)
  end

  def remove_log
    log_path = File.expand_path("../log/production.log", __FILE__)
    File.unlink log_path if File.exists? log_path
  end

  def ensure_database
    unless File.exists? db_path("empty_snapshot.sqlite3")
      # make sure we have a database
      STDERR.puts `bundle exec rake db:setup --trace`
      FileUtils.cp db_path("development.sqlite3"), db_path("empty_snapshot.sqlite3")
    end

    # replace existing databases
    ['development.sqlite3', 'production.sqlite3', 'test.sqlite3'].each do |file|
      File.unlink db_path(file) if File.exists? db_path(file)
      FileUtils.cp db_path("empty_snapshot.sqlite3"), db_path(file)
    end
  end

  def start_production_server(bash)
    bash.puts "RAILS_ENV=production #{ENV['RUBY_COMMAND']} script/rails s -p3009 >& /dev/null &"

    timeout_start = Time.now
    sleep 0.2 until server_running? || (Time.now - timeout_start > 120)
  end

  def server_pid
    `curl localhost:3009/pid 2> /dev/null`.to_i
  end

  def server_running?
    `curl localhost:3009/ 2> /dev/null`.size > 0
  end

  def server_working?
    `curl localhost:3009/ 2> /dev/null` =~ /<title>eHarbor<\/title>/
  end

  def kill_server
    system("kill -9 #{server_pid}") ? (STDERR.puts "server killed") : (STDERR.puts "SERVER NOT KILLED!!!")
  end

  def load_server(options)
    output = if request_count = options[:request_count]
      `ab -n #{request_count} http://127.0.0.1:3009/ 2>&1`
    elsif seconds = options[:seconds]
      `ab -t #{seconds} http://127.0.0.1:3009/ 2>&1`
    else
      raise "need to provide either :request_count or :seconds option!"
    end
    STDERR.puts output if options[:log_results_to_stderr]

    requests_per_second = output[/Transaction rate:\s*([\d\.]+)/, 1].to_f
    requests_per_second
  end

  def ensure_server_not_running
    if server_running?
      STDERR.puts "Oops, web server already running!"
      kill_server
    end
  end

  def with_server_in_bash(&block)
    success = true

    IO.popen("bash", "w") do |bash|
    	# jruby doesn't have fork...
      start_production_server(bash)

      begin
        if server_working?
          yield(bash)
        else
          success = false
        end
      ensure
        kill_server
      end
    end

    success
  end

  def benchmark_with_server_in_bash(options, &block)
    runs = ENV['IRFY_DEV_MODE'] == 'true' ? 1 : options[:runs]
    success = true

    results = (1..runs).map do
      next unless success
      result = nil

      success = with_server_in_bash do |bash|
        result = yield(bash)
      end

      result
    end

    if success
      # take the mean of the runs
      results.inject(0.0) { |sum, r| sum + r } / runs
    else
      exit(1)
    end
  end
end