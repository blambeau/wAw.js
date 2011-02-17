exports.Slot = class Slot

  constructor: ->
    @listeners = []

  wBind: (l) ->
    @listeners.push(l)
    this

  wEmit: ->
    l(arguments...) for l in @listeners
