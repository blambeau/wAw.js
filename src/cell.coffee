{Base} = require './base'

#
# A Memory/State Cell supporting a 'changed' slot
#
exports.Cell = class Cell extends Base

  constructor: (@value) ->
    super
    this.slot('changed')

  get: -> 
	  @value

  set: (value) ->
    oldval = @value
    @value = value
    this.emit("changed", this, oldval, value)
    @value

  listen: (fn) -> 
    this.bind('changed', fn)

  fetch: (sel) ->
	  if this.has_slot(sel)
      this.slot(sel)
    else
      raise "No such slot #{sel}"
