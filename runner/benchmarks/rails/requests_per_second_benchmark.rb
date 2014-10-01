require File.expand_path("../benchmark_helper.rb", __FILE__)
include BenchmarkHelper

ensure_database
ensure_server_not_running
remove_log

final_requests_per_second_result = benchmark_with_server_in_bash(:runs => 4) do |bash|
  STDERR.puts "cooling off..."
  sleep 20 unless ENV['IRFY_DEV_MODE'] == 'true'

  STDERR.puts "warmup..."
  load_server(:request_count => 300)

  STDERR.puts "testing..."
  requests_per_second = load_server(:request_count => 1500, :log_results_to_stderr => true)
end

puts "#{final_requests_per_second_result} requests per second"