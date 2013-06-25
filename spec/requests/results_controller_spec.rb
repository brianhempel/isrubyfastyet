require 'spec_helper'
require 'fileutils'

describe "/benchmarks/benchmark_param/results" do
  before :all do
    @results_dir = File.expand_path('../../tmp/results', __FILE__)
    FileUtils.makedirs(@results_dir)
    BenchmarkResultSet.results_dir = @results_dir
  end

  before do
    # remove result files
    Dir.glob(File.join(@results_dir, '*')).each { |path| File.unlink(path) }

    create_result_file("benchmark_1_results.tsv", <<-RESULTS)
2012-01-12 07:23:49 UTC	1.8.7	56.6861324310303 MB	ruby 1.8.7 (2011-06-30 patchlevel 352) [i686-darwin10.8.0]
2012-01-12 07:23:49 UTC	1.8.7	failed	ruby 1.8.7 (2011-06-30 patchlevel 352) [i686-darwin10.8.0]
2012-01-12 08:55:44 UTC	jruby-head	208.656998634338 MB	jruby 1.7.0.dev (ruby-1.8.7-p357) (2012-01-12 0e83d96) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]
    RESULTS
  end

  def create_result_file(name, data)
    File.join(@results_dir, name).tap do |path|
      File.open(path, "w") { |f| f.write(data) }
    end
  end

  describe ".json" do
    it "returns all the results" do
      visit "/benchmarks/benchmark_1/results.json"

      page.source.should be_json_like(<<-JSON)
        {
          "benchmark": {
            "name":  "Benchmark 1",
            "param": "benchmark_1",
            "units": "MB"
          },
          "results": [
            {
              "time_str":     "2012-01-12 07:23:49 UTC",
              "time_ms":      1326353029000,
              "rvm_name":     "1.8.7",
              "result":       56.6861324310303,
              "full_version": "ruby 1.8.7 (2011-06-30 patchlevel 352) [i686-darwin10.8.0]"
            },
            {
              "time_str":     "2012-01-12 08:55:44 UTC",
              "time_ms":      1326358544000,
              "rvm_name":     "jruby-head",
              "result":       208.656998634338,
              "full_version": "jruby 1.7.0.dev (ruby-1.8.7-p357) (2012-01-12 0e83d96) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]"
            }
          ]
        }
      JSON
    end
  end
end