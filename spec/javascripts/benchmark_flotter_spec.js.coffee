parsed_json = {
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
    },
    {
      "time_str":     "2012-02-14 07:15:35 UTC",
      "time_ms":      1329203735000,
      "rvm_name":     "jruby-head",
      "result":       209.65935277938843,
      "full_version": "jruby 1.7.0.dev (ruby-1.9.3-p28) (2012-02-14 c867d1f) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]"
    }
  ]
}

describe "BenchmarkFlotter", ->
  it "takes a url", ->
    benchmark_flotter = new BenchmarkFlotter parsed_json

  it "makes tabular, flottable data", ->
    benchmark_flotter = new BenchmarkFlotter parsed_json
    expect(benchmark_flotter.flotData().length).toEqual(2)
    expect(benchmark_flotter.flotData()[0]['label']).toBeDefined()
    expect(benchmark_flotter.flotData()[0]['data']).toBeDefined()
    expect(benchmark_flotter.flotData()[0]['data'].length).toBeDefined()

  it "makes the correct flottable data", ->
    benchmark_flotter = new BenchmarkFlotter parsed_json
    expect(benchmark_flotter.flotData()).toEqual([
      {
        label:    "1.8.7",
        data:     [[new Date(1326353029000), 56.6861324310303]]
        fullData: [
          {
            "time_str":     "2012-01-12 07:23:49 UTC",
            "time_ms":      1326353029000,
            "rvm_name":     "1.8.7",
            "result":       56.6861324310303,
            "full_version": "ruby 1.8.7 (2011-06-30 patchlevel 352) [i686-darwin10.8.0]"
          }
        ]
      },
      {
        label: "jruby-head",
        data: [[new Date(1326358544000), 208.656998634338], null, [new Date(1329203735000), 209.65935277938843]],
        fullData: [
          {
            "time_str":     "2012-01-12 08:55:44 UTC",
            "time_ms":      1326358544000,
            "rvm_name":     "jruby-head",
            "result":       208.656998634338,
            "full_version": "jruby 1.7.0.dev (ruby-1.8.7-p357) (2012-01-12 0e83d96) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]"
          },
          null,
          {
            "time_str":     "2012-02-14 07:15:35 UTC",
            "time_ms":      1329203735000,
            "rvm_name":     "jruby-head",
            "result":       209.65935277938843,
            "full_version": "jruby 1.7.0.dev (ruby-1.9.3-p28) (2012-02-14 c867d1f) (Java HotSpot(TM) 64-Bit Server VM 1.6.0_29) [darwin-x86_64-java]"
          }
        ]
      }
    ])

  it "orders the rubies by the Ruby.rubies hash", ->
    out_of_order_json = {
      "results": [
        {"rvm_name": "jruby-head"},
        {"rvm_name": "1.9.3-head"},
        {"rvm_name": "1.8.7"},
      ]
    }
    benchmark_flotter = new BenchmarkFlotter out_of_order_json
    labels = (series.label for series in benchmark_flotter.flotData())
    expect(labels).toEqual(["1.8.7", "1.9.3-head", "jruby-head"])

  describe "#units", ->
    it 'returns "MB" for "MB"', ->
      unit_json = {"benchmark": {"units": "MB"}}
      benchmark_flotter = new BenchmarkFlotter unit_json
      expect(benchmark_flotter.units()).toEqual("MB")

    it 'returns "rps" for "requests per second"', ->
      unit_json = {"benchmark": {"units": "requests per second"}}
      benchmark_flotter = new BenchmarkFlotter unit_json
      expect(benchmark_flotter.units()).toEqual("rps")

    it 'returns "s" for "seconds"', ->
      unit_json = {"benchmark": {"units": "seconds"}}
      benchmark_flotter = new BenchmarkFlotter unit_json
      expect(benchmark_flotter.units()).toEqual("s")

  describe "#colors", ->
    original_rubies = {}

    beforeEach ->
      original_rubies = Ruby.rubies
      Ruby.rubies =
          "1.8.7":      new Ruby("1.8.7",      "#f00"),
          "1.9.3-head": new Ruby("1.9.3-head", "#0f0"),
          "jruby-head": new Ruby("jruby-head", "#00f")

    afterEach ->
      Ruby.rubies = original_rubies

    it "returns the appropriate colors for the series", ->
      minimal_json = {
          "results": [
            {"rvm_name": "1.8.7"},
            {"rvm_name": "jruby-head"},
          ]
        }
      benchmark_flotter = new BenchmarkFlotter minimal_json
      expect(benchmark_flotter.seriesColors()).toEqual(["#f00", "#00f"])
