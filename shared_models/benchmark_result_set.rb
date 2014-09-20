class BenchmarkResultSet < Struct.new(:results_file_path)
  class Result < Struct.new(:time_str, :rvm_name, :value_with_units, :version_string)
    def self.from_tsv_line(line)
      time_str, rvm_name, value_with_units, version_string = line.chomp.split("\t")
      new(time_str, rvm_name, value_with_units, version_string)
    end

    def to_f
      value_with_units.to_f if success?
    end

    def success?
      @success ||= !!(value_with_units =~ /^\s*[\-+]?\.?\d/)
    end

    def units
      value_with_units.sub(/^\s*\S+\s*/, '') if success?
    end

    def result
      to_f
    end

    def value
      to_f
    end

    def full_version
      version_string
    end

    def time
      # "2012-01-30 09:31:21 UTC"
      match = /(\d+)-(\d+)-(\d+) (\d+):(\d+):(\d+) UTC/.match(time_str)
      year, month, day, hour, minute, second = match.captures.map(&:to_i)
      Time.new(year, month, day, hour, minute, second, "+00:00")
    end

    def time_ms
      ((time - Time.new(1970, 1, 1, 0, 0, 0, "+00:00")) * 1000).round
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

  def oldest_result
    all_results.sort_by { |result| result.time }.first
  end

  def oldest_result_time
    oldest_result.time
  end

  def results_by_rvm_name(rvm_name)
    all_results.select { |r| r.rvm_name == rvm_name }
  end

  def all_results
    File.read(results_file_path).lines.map { |line| Result.from_tsv_line(line) }
  end
end