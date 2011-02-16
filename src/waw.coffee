exports.Cell = class Cell
  constructor: ->
	  @value = null
	  @listeners = []

  get: ->
	  @value

  set: (value) ->
    @value = value
    for l in @listeners
	    l(this)

  add_listener: (listener) ->
    @listeners.push(listener)
