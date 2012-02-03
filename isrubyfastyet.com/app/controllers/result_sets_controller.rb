class ResultSetsController < ApplicationController
  respond_to :json

  def index
    @result_sets = BenchmarkResultSet.all
    respond_with @result_sets
  end
end