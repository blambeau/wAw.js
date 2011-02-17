exports.Slot = class Slot

  constructor: (@brick) ->
    @listeners = []

  bind: (l) ->
    @listeners.push(l)
    this

  listen: (l) ->
	  this.bind(l)

  emit: ->
    l(arguments...) for l in @listeners
