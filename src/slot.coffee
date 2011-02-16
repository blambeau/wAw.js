exports.Slot = class Slot

  constructor: (@base) ->
    @listeners = []

  bind: (l) ->
    @listeners.push(l)
    this

  emit: ->
    l(arguments...) for l in @listeners
