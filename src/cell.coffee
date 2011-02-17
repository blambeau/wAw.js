{Brick} = require './brick'

#
# A Memory/State Cell supporting a 'changed' slot
#
exports.Cell = class Cell extends Brick

  constructor: (@value) ->
    super
    @changed = this.wSlot('changed')

  get: -> 
	  @value
	
  set: (value) ->
    oldval = @value
    @value = value
    @changed.emit(this, oldval, value)
    @value

  listen: (fn) -> 
    this.wBind('changed', fn)
