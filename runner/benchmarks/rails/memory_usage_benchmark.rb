require File.expand_path("../benchmark_helper.rb", __FILE__)
include BenchmarkHelper

ensure_database
ensure_server_not_running
remove_log

final_memory_usage_bytes_result = benchmark_with_server_in_bash(:runs => 6) do |bash|
  sample_count    = 30
  sample_duration = 15
  pid             = server_pid

  # put load on the web server...
  bash.puts "siege -t #{sample_duration*2 + 2}s -b -c1 -q http://localhost:3009/ &"
  sleep 2

  # take some samples
  memory_usage_bytes = (1..sample_count).map do 
    sleep(sample_duration.to_f / sample_count)
    `ps -o rss -p #{pid}`[/\d+\s*$/].to_i * 1024
  end.inject(0) { |sum, bytes| sum + bytes } / sample_count

  # stop siege
  bash.puts("kill -9 %2")

  memory_usage_bytes
end

puts "#{final_memory_usage_bytes_result.to_f / 1024 / 1024} MB"
