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
    @changed.wEmit(this, oldval, value)
    @value

  listen: (fn) -> 
    this.wBind('changed', fn)
