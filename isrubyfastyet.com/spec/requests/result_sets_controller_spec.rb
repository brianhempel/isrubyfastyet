require 'spec_helper'

describe "/result_sets" do
  let :result_sets do
    [
      BenchmarkResultSet.new,
      BenchmarkResultSet.new
    ].each_with_index { |rs, i| rs.stub(:name => "Benchmark #{i+1}") }
  end

  describe ".json" do
    it "returns a list of all benchmarks" do
      BenchmarkResultSet.stub(:all) { result_sets }

      visit "/result_sets.json"

      page.source.should be_json_like(<<-JSON)
        {
          "result_sets": [
            { "name": "Benchmark 1" },
            { "name": "Benchmark 2" }
          ]
        }
      JSON
    end
  end
end