class BenchmarksController < ApplicationController
  respond_to :json

  def index
    @benchmarks = BenchmarkResultSet.all
    respond_with @benchmarks
  end
end