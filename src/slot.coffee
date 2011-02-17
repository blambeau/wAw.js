exports.Slot = class Slot

  constructor: ->
    @listeners = []

  wBind: (l) ->
    @listeners.push(l)
    this

  emit: ->
    l(arguments...) for l in @listeners
