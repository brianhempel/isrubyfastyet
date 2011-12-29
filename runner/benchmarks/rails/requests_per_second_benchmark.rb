require File.expand_path("../benchmark_helper.rb", __FILE__)
include BenchmarkHelper

ensure_database
ensure_server_not_running

IO.popen("bash", "w") do |bash|
  # jruby doesn't have fork...
  start_production_server(bash)

  if server_working?
    STDERR.puts "warmup..."
    apache_bench = `ab -t 3 localhost:3009/`
    # STDERR.puts apache_bench

    STDERR.puts "testing..."
    apache_bench = `ab -t 15 localhost:3009/`
    STDERR.puts apache_bench

    @requests_per_second = apache_bench[/Requests per second:\s*([\d\.]+)/, 1].to_f
    @success = true
  else
    @success = false
  end

  kill_server
end

if @success
  puts "#{@requests_per_second} requests per second"
  exit(0)
else
  exit(1)
end