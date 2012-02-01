class BenchmarkResultSet < Struct.new(:results_file_path)
  class Result < Struct.new(:rvm_name, :value_with_units)
    def self.from_tsv_line(line)
      time_str, rvm_name, value_with_units, version_string = line.chomp.split("\t")
      new(rvm_name, value_with_units)
    end

    def to_f
      value_with_units.to_f if success?
    end

    def success?
      !!(value_with_units =~ /^\s*[\-+]?\.?\d/)
    end
  end

  class << self
    attr_accessor :results_dir

    def all
      result_paths = Dir.glob(File.join(results_dir, '*_results.tsv'))

      result_paths.map { |results_file_path| new(results_file_path) }
    end
  end

  def name
    results_file_path[%r{/([^/]+)_results.tsv}, 1]
  end

  def results_by_rvm_name(rvm_name)
    all_results.select { |r| r.rvm_name == rvm_name }
  end

  def all_results
    File.read(results_file_path).lines.map { |line| Result.from_tsv_line(line) }
  end
end