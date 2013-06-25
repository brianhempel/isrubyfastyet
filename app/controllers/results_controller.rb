class ResultsController < ApplicationController
  respond_to :json

  def index
    @benchmark = RubyBenchmark.from_param(params[:benchmark_id])
    @results = @benchmark.passing_results
  end
end
