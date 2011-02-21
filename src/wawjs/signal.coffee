exports.Signal = class Signal

  constructor: (@brick) ->
    @listeners = []

  listen: (l) ->
    @listeners.push(l)
    this
    
  unlisten: (l)->
    index = null
    for candidate, i in @listeners
      index = i if candidate == l
    @listeners.splice(index, 1) if index?

  emit: ->
    l(arguments...) for l in @listeners
