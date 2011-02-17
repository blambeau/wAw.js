{Cell} = require './cell'
{Slot} = require './slot'

exports.SM = class SM extends Cell
  
  constructor: (@def) ->
    super
    this.set(null)

  value_for: (key) ->
    @def[key]

  init: ->
    self = this
    for k,v of @def
      self.wFetch(k).listen (cell, oldval, newval) ->
        self.set self.value_for(cell.wid())
    this
