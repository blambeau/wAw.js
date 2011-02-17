exports.Signal = class Signal

  constructor: (@brick) ->
    @listeners = []

  listen: (l) ->
    @listeners.push(l)
    this

  emit: ->
    l(arguments...) for l in @listeners
