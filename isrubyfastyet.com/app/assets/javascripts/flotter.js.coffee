class this.BenchmarkFlotter
  constructor: (@parsed_json) ->

  flotData: ->
     for rvm_name, results of this.resultsByRvmName()
       {
         label: rvm_name,
         data: ([new Date(result.time_ms), result.result] for result in results)
       }

  resultsByRvmName: ->
    rubies = {}
    this.matchResult(rubies, result) for result in @parsed_json['results']
    rubies

  matchResult: (rubies, result) ->
    rubies[result['rvm_name']] ||= []
    rubies[result['rvm_name']].push result
