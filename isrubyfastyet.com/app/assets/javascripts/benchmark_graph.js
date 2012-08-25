unit_abbreviations = {
  "requests per second": "rps",
  "seconds":             "s"
}

function getResultsJSON(benchmark_name, start_time, callback) {
  var query_string = ''
  if (start_time) {
    query_string = '?start_time=' + start_time
  }
  var url = 'benchmarks/' + benchmark_name +'/results.json' + query_string;
  $.getJSON(url, callback);
}

$.fn.drawBenchmarkGraphFromJSON = function(json) {
  var flotter = new BenchmarkFlotter(json);
  var units   = unit_abbreviations[json.benchmark.units] || json.benchmark.units
  $.plot(this, flotter.flotData(), {
    colors: flotter.seriesColors(),
    lines:  { show: true, opacity: 0.3 },
    points: { show: true },
    grid:   { backgroundColor: { colors: ['#fff', 'rgba(255, 255, 255, 0.7)'] } },
    xaxis: {
      mode: "time",
      timeformat: "%y/%m/%d",
      ticks: 5
    },
    yaxis: {
      min: 0,
      tickFormatter: function (n) { return "" + n + units; }
    },
    legend: {
      position: 'nw',
      backgroundOpacity: 0.7,
      container: this.next()
    }
  });
}

$.fn.drawBenchmarkGraph = function(start_time) {
  var benchmark_name = $(this).data('graph-benchmark');
  var $element = this;
  getResultsJSON(benchmark_name, start_time, function(json) {
    $element.drawBenchmarkGraphFromJSON(json);
  });
}

$(function () {

  $('*[data-graph-benchmark]').each(function () {
    var default_start_time = $(this).data('graph-default-start-time');
    $(this).drawBenchmarkGraph(default_start_time);
  });

  $('*[data-on-click-load-graph]').each(function () {
    var graph      = $($(this).data('on-click-load-graph'));
    var start_time = $(this).data('graph-start-time');
    $(this).click(function(event) {
      event.preventDefault();
      graph.drawBenchmarkGraph(start_time);
    });
  });

});
