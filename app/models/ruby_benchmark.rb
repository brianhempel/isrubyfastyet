class RubyBenchmark
  def self.from_param(param)
    result_set = BenchmarkResultSet.all.find { |result_set| result_set.name == param }
    new(result_set) if result_set
  end

  attr_accessor :result_set

  def initialize(result_set=nil)
    @result_set = result_set
  end

  def name
    param.titleize
  end

  def param
    result_set.name
  end

  def units
    all_results.find { |result| result.success? }.try(:units)
  end

  def passing_results
    all_results.select(&:success?)
  end

  def method_missing(method, *args)
    if result_set.respond_to?(method)
      result_set.send(method)
    else
      super
    end
  end
end