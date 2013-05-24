require 'fileutils'

module BenchmarkHelper
  def db_path(file)
    File.expand_path("../db/#{file}", __FILE__)
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
    runs = options[:runs]
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