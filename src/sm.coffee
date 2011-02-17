{Cell} = require './cell'
{Signal} = require './signal'

exports.SM = class SM extends Cell
  
  constructor: (@def) ->
    super
    this.set(null)

  value_for: (key) ->
    @def[key]

  _build_fn: (k, v) ->
    => this.set(v) 

  wInit: (parent, name) ->
    for k,v of @def
      this.wListen(k, this._build_fn(k, v)) 
    this
