require 'spec_helper'

describe "/benchmarks" do
  let :result_sets do
    [
      BenchmarkResultSet.new,
      BenchmarkResultSet.new
    ].each_with_index { |rs, i| rs.stub(:name => "Benchmark #{i+1}") }
  end

  describe ".json" do
    it "returns a list of all benchmarks" do
      BenchmarkResultSet.stub(:all) { result_sets }

      visit "/benchmarks.json"

      page.source.should be_json_like(<<-JSON)
        {
          "benchmarks": [
            { "name": "Benchmark 1" },
            { "name": "Benchmark 2" }
          ]
        }
      JSON
    end
  end
end