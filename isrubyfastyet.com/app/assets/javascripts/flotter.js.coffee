class this.BenchmarkFlotter
  constructor: (@parsed_json) ->

  flotData: ->
     for rvm_name, results of this.resultsByRvmName()
       {
         label: rvm_name,
         data: this.filterFlotPoints(results)
       }

  # add nulls between points > 14 days apart
  filterFlotPoints: (json_results_array) ->
    filtered_results = []
    last_date       = null
    for result in json_results_array
      result_date = new Date(result.time_ms)
      filtered_results.push null if last_date and result_date - last_date > 1000*60*60*24*14 # 14 days
      filtered_results.push [result_date, result.result]
      last_date = result_date
    filtered_results

  resultsByRvmName: ->
    results_by_rvm_name = {}
    this.matchResult(results_by_rvm_name, result) for result in @parsed_json['results']
    sorted_results_by_rvm_name = {}
    for rvm_name in Ruby.ruby_names
      sorted_results_by_rvm_name[rvm_name] = results_by_rvm_name[rvm_name] if results_by_rvm_name[rvm_name]
    sorted_results_by_rvm_name

  matchResult: (results_by_rvm_name, result) ->
    results_by_rvm_name[result['rvm_name']] ||= []
    results_by_rvm_name[result['rvm_name']].push result
