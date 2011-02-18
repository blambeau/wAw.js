{Brick} = require './brick'
{Signal} = require './signal'

#
# A Memory/State Cell supporting a 'changed' signal
#
exports.Cell = class Cell extends Brick

  constructor: (@value) ->
    super
    @changed = new Signal(this)

  get: -> 
    @value
  
  set: (value) ->
    oldval = @value
    @value = value
    @changed.emit(this, oldval, value)
    @value

  listen: (fn) -> 
    this.wListen('changed', fn)

  toString: ->
    v = this.get()
    if v? 
      v.toString()
    else
      null