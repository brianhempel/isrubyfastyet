require File.expand_path('../isrubyfastyet', __FILE__)

class BenchmarkResultSet < Struct.new(:results_file_path)
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
    result_paths = Dir.glob(irfy_path('results/*_results.tsv'))

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