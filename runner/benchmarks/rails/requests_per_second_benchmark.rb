require File.expand_path("../benchmark_helper.rb", __FILE__)
include BenchmarkHelper

ensure_database
ensure_server_not_running
remove_log

final_requests_per_second_result = benchmark_with_server_in_bash(:runs => 4) do |bash|
  STDERR.puts "cooling off..."
  sleep 20 unless ENV['IRFY_DEV_MODE'] == 'true'

  STDERR.puts "warmup..."
  load_server(:seconds => 3)

  STDERR.puts "testing..."
  requests_per_second = load_server(:seconds => 15, :log_results_to_stderr => true)
end

puts "#{final_requests_per_second_result} requests per second"