require 'rubygems'
require 'easystats'

def relative_path(path)
  File.join(File.dirname(__FILE__), path)
end

class Ruby < Struct.new(:rvm_name)
  def self.all_stable
    all.select { |ruby| ruby.rvm_name !~ /-head/ }
  end

  def self.all
    rows = File.read(relative_path('runner/rubies')).lines.map(&:chomp).select { |line| line !~ /^\s*#/ }.map { |line| line.split(/\s\s+/) }

    headers = rows.shift

    rows.map do |row|
      {}.tap do |hash|
        row.each_with_index do |cell, i|
          hash.merge!(headers[i] => cell)
        end
      end
    end.map { |row_hash| new(row_hash['RVM Name']) }
  end
end

class RubyBenchmark < Struct.new(:results_file_path)
  class Result < Struct.new(:rvm_name, :value_with_units)
    def self.from_tsv_line(line)
      time_str, rvm_name, value_with_units, version_string = line.chomp.split("\t")
      new(rvm_name, value_with_units)
    end

    def to_f
      value_with_units.to_f
    end
  end

  def self.all
    result_paths = Dir.glob(relative_path('results/*_results.tsv'))

    result_paths.map { |results_file_path| new(results_file_path) }
  end

  def name
    results_file_path[%r{/([^/]+)_results.tsv}, 1]
  end

  def results_by_ruby(rvm_name)
    all_results.select { |r| r.rvm_name == rvm_name }
  end

  def all_results
    File.read(results_file_path).lines.map { |line| Result.from_tsv_line(line) }
  end
end

desc "Is the benchmark producing consistent ouput? Show how different the last result vs. the median of the 5 previous results for stable rubies"
task :variability do
  offset = (ENV['OFFSET'] ? ENV['OFFSET'].to_i : 0)
  previous_count = (ENV['PREVIOUS'] ? ENV['PREVIOUS'].to_i : 5)

  benchmark_variabilites = RubyBenchmark.all.map do |benchmark|

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