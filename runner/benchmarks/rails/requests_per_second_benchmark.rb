require File.expand_path("../benchmark_helper.rb", __FILE__)
include BenchmarkHelper

ensure_database
ensure_server_not_running

final_requests_per_second_result = benchmark_with_server_in_bash(:runs => 4) do |bash|

  STDERR.puts "warmup..."
  apache_bench = `ab -t 3 localhost:3009/`
  # STDERR.puts apache_bench

  STDERR.puts "testing..."
  apache_bench = `ab -t 15 localhost:3009/`
  STDERR.puts apache_bench

  requests_per_second = apache_bench[/Requests per second:\s*([\d\.]+)/, 1].to_f
end

puts "#{final_requests_per_second_result} requests per second"