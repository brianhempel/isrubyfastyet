require File.expand_path("../benchmark_helper.rb", __FILE__)
include BenchmarkHelper

ensure_database
ensure_server_not_running
remove_log

module Enumerable
  def sum
    inject(0) { |sum, x| sum + x }
  end

  def mean
    sum.to_f / count
  end

  def standard_deviation
    return nil if count == 1
    mean = self.mean
    Math.sqrt( map { |x| (x - mean)**2 }.sum / (count - 1) )
  end

  def coefficient_of_variation
    naive_sd = standard_deviation / mean
    # wikipedia says to do this to avoid underestimating for small datasets
    naive_sd * (1.0 + 1.0 / (4*count))
  end
end

results = []
runs    = ENV['IRFY_DEV_MODE'] == 'true' ? 1 : 4

with_server_in_bash do |bash|

  warmup_round_requests       = 250
  coefficient_of_variation    = nil
  run_number                  = 0
  requests_per_second_history = []
  warmup_start_time           = Time.now
  warmup_time_limit           = ENV['IRFY_DEV_MODE'] == 'true' ? 15 : 15*60
  requests_processed          = 0
  elapsed_seconds             = 0
  target_cov                  = 0.01
  early_abort_cov             = 0.05
  number_of_runs_to_consider  = 6
  STDERR.puts "Warming up to steady state..."
  begin
    run_number += 1

    STDERR.print "Running #{warmup_round_requests} requests..."
    requests_per_second = load_server(:request_count => warmup_round_requests)
    STDERR.print "#{requests_per_second} requests per second"
    requests_processed += warmup_round_requests

    warmup_round_requests += 250

    requests_per_second_history << requests_per_second
    if recent_runs = requests_per_second_history[-number_of_runs_to_consider..-1]
      coefficient_of_variation = recent_runs.coefficient_of_variation
      STDERR.print("\t(%5.2f%% coefficient of variation over last #{number_of_runs_to_consider} runs)" % [coefficient_of_variation*100])
    end
    STDERR.puts
    elapsed_seconds = Time.now - warmup_start_time
  end until elapsed_seconds > warmup_time_limit || run_number == number_of_runs_to_consider && coefficient_of_variation < early_abort_cov || coefficient_of_variation && coefficient_of_variation < target_cov
  STDERR.puts "Interpreter not behaving like it has a JIT (COV < #{early_abort_cov*100}% on first test). Ending warmup." if run_number == number_of_runs_to_consider
  STDERR.puts "Time limit exceeded." if elapsed_seconds > warmup_time_limit
  STDERR.puts("#{requests_processed} requests processed over %.2fm" % [elapsed_seconds / 60.0])

  STDERR.puts "cooling off from long warmup..."
  sleep 60  unless ENV['IRFY_DEV_MODE'] == 'true'

  runs.times do
    STDERR.puts "cooling off..."
    sleep 20  unless ENV['IRFY_DEV_MODE'] == 'true'

    STDERR.puts "warmup..."
    load_server(:request_count => 300)

    STDERR.puts "testing..."
    requests_per_second = load_server(:request_count => 1500, :log_results_to_stderr => true)

    results << requests_per_second
  end
end

if results.size > 0
  # take the mean of the runs
  final_requests_per_second_result = results.sum / runs
else
  exit(1)
end

puts "#{final_requests_per_second_result} requests per second"