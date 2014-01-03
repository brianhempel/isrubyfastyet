function getResultsJSON(benchmark_name, callback) {
  var url = '/benchmarks/' + benchmark_name +'/results.json';
  $.getJSON(url, callback);
}

$.fn.drawBenchmarkGraphFromJSON = function(json, start_time) {
  var flotter = new BenchmarkFlotter(json, start_time);
  this.data('flotter', flotter);
  $.plot(this, flotter.flotData(), {
    colors: flotter.seriesColors(),
    lines:  { show: true, opacity: 0.3 },
    points: { show: true },
    grid:   {
      backgroundColor: { colors: ['#fff', 'rgba(255, 255, 255, 0.6)'] },
      hoverable: true,
      mouseActiveRadius: 20
    },
    xaxis: {
      mode: "time",
      timeformat: "%Y-%m-%d",
      ticks: 5
    },
    yaxis: {
      min: 0,
      tickFormatter: function (n) { return "" + n + flotter.units(); }
    },
    legend: {
      position: 'nw',
      backgroundOpacity: 0.7,
      toggle: true,
      container: this.parent().find('.legend')
    }
  });
}

$.fn.drawBenchmarkGraph = function(start_time) {
  var benchmark_name = $(this).data('graph-benchmark');
  var $element = this;
  getResultsJSON(benchmark_name, function(json) {
    $element.drawBenchmarkGraphFromJSON(json, start_time);
  });
}

function showTooltip($graph, item) {
  var offset     = $graph.data('plot').pointOffset({ x: item.datapoint[0], y: item.datapoint[1]});
  var flotter    = $graph.data('flotter');
  var point_data = flotter.flotData()[item.seriesIndex].fullData[item.dataIndex];
  var content    = '<div class="rvm-name">'     + point_data["rvm_name"]                            + '</div>' +
                   '<div class="result">'       + point_data["result"].toFixed(2) + flotter.units() + '</div>' +
                   '<div class="full-version">' + point_data["full_version"]                        + '</div>' +
                   '<div class="time">'         + (new Date(point_data["time_ms"]))                 + '</div>';

  $('<div id="graph-tooltip">' + content + '</div>').css({
    top:            offset.top  + 4,
    left:           offset.left + 10,
    "border-color": item.series.color
  }).appendTo($graph).fadeIn(200);
}

$(window).load(function () {

  $('*[data-graph-benchmark]').each(function () {
    var previousPointDataIndex;
    var previousPointSeriesIndex;
    $(this).bind("plothover", function (event, pos, item) {
      if (item) {
        if (previousPointDataIndex != item.dataIndex || previousPointSeriesIndex != item.seriesIndex) {
          previousPointDataIndex   = item.dataIndex;
          previousPointSeriesIndex = item.seriesIndex;

          $("#graph-tooltip").remove();
          var x = item.datapoint[0].toFixed(2),
              y = item.datapoint[1].toFixed(2);

          showTooltip($(this), item);
        }
      } else {
        $("#graph-tooltip").remove();
        previousPointDataIndex   = null;
        previousPointSeriesIndex = null;
      }
    });
  });

  $('*[data-on-click-load-graph]').each(function () {
    var graph      = $($(this).data('on-click-load-graph'));
    var start_time = new Date($(this).data('graph-start-time'));
    $(this).click(function(event) {
      event.preventDefault();
      graph.drawBenchmarkGraph(start_time);
    });
  });

});
