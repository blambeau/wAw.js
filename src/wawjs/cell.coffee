{Brick} = require './brick'
{Signal} = require './signal'

#
# A Memory/State Cell supporting a 'changed' signal
#
exports.Cell = class Cell extends Brick

  constructor: (@_value) ->
    super
    @changed = new Signal(this)

  get: -> 
    @_value
  
  set: (value) ->
    oldval = @_value
    @_value = value
    @changed.emit(this, oldval, value)
    @_value

  listen: (fn) -> 
    this.wListen('changed', fn)

  unlisten: (fn) -> 
    this.wUnlisten('changed', fn)

  toString: ->
    v = this.get()
    if v? 
      v.toString()
    else
      null