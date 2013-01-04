class ResultsController < ApplicationController
  respond_to :json

  def index
    @benchmark = RubyBenchmark.from_param(params[:benchmark_id])
    @results = filter_by_params(@benchmark.passing_results, params)
  end

  private

  def filter_by_params(results, params)
    return results unless params[:start_time].present?
    start_time = Time.zone.parse(params[:start_time]).utc
    results.select { |result| start_time <= result.time }
  end
end
