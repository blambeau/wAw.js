exports.Slot = class Slot

  constructor: ->
    @listeners = []

  bind: (l) ->
    @listeners.push(l)
    this

  emit: ->
    l(arguments...) for l in @listeners
