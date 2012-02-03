require 'spec_helper'

describe ResultSetsController do
  let :result_sets do
    [
      BenchmarkResultSet.new,
      BenchmarkResultSet.new
    ].each_with_index { |rs, i| rs.stub(:name => "Benchmark #{i+1}") }
  end

  render_views

  describe "GET index.json" do
    it "returns a list of all benchmarks" do
      BenchmarkResultSet.stub(:all) { result_sets }

      get :index, :format => :json

      response.body.should be_json_like(<<-JSON)
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