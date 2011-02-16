{Brick} = require './brick'

#
# A Memory/State Cell supporting a 'changed' slot
#
exports.Cell = class Cell extends Brick

  constructor: (@value) ->
    super
    @changed = this.slot('changed')

  get: -> 
	  @value

  set: (value) ->
    oldval = @value
    @value = value
    this.emit("changed", this, oldval, value)
    @value

  listen: (fn) -> 
    this.bind('changed', fn)
