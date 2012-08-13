class ResultsController < ApplicationController
  respond_to :json

  def index
    @benchmark = RubyBenchmark.from_param(params[:benchmark_id])
    @results = filter_by_params(@benchmark.passing_results, params)
  end

  private

  def filter_by_params(results, params)
    results.select do |result|
      if params[:start_time].present?
        Time.zone.parse(params[:start_time]).utc <= result.time
      else
        true
      end
    end
  end
end
