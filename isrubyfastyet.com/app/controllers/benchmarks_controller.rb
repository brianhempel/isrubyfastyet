class BenchmarksController < ApplicationController
  respond_to :json

  def index
    @benchmarks = BenchmarkResultSet.all
  end
end