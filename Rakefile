require File.expand_path('../isrubyfastyet', __FILE__)

require 'easystats'
require 'ruby'
require 'benchmark_result_set'


desc "Is the benchmark producing consistent ouput? Show how different the last result vs. the median of the 5 previous results for stable rubies"
task :variability do
  offset = (ENV['OFFSET'] ? ENV['OFFSET'].to_i : 0)
  previous_count = (ENV['PREVIOUS'] ? ENV['PREVIOUS'].to_i : 5)

  benchmark_variabilites = BenchmarkResultSet.all.map do |benchmark|

    puts
    puts benchmark.name

    variabilities = Ruby.all_stable.map do |ruby|
      ruby_results = benchmark.results_by_ruby(ruby.rvm_name).map(&:to_f)

      last_result   = ruby_results[offset-1]
      previous_results = ruby_results[0..(offset-2)].last(previous_count)
      previous_results = previous_results.median

      variability = (last_result - previous_results) / previous_results
      puts "%s: %.2f%%" % [ruby.rvm_name, variability * 100.0]

      variability
    end

    absolute_variabilities = variabilities.map(&:abs)
    
    benchmark_variability = variabilities[absolute_variabilities.find_index(absolute_variabilities.max)]
    puts "  max: %.2f%%" % [benchmark_variability * 100.0]

    benchmark_variability
  end

  absolute_benchmark_variabilities = benchmark_variabilites.map(&:abs)
  suite_variability = benchmark_variabilites[absolute_benchmark_variabilities.find_index(absolute_benchmark_variabilities.max)]

  puts
  puts "suite: %.2f%%" % [suite_variability * 100.0]
  puts
end