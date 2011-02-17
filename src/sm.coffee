{Cell} = require './cell'
{Signal} = require './signal'

exports.SM = class SM extends Cell
  
  constructor: (@def) ->
    super
    this.set(null)

  value_for: (key) ->
    @def[key]

  wInit: (parent, name) ->
    for k,v of @def
      this.wListen(k, this._build_fn(k, v)) 
    this

  _build_fn: (k, v) ->
    if (typeof(v) == "function")
      (arguments...) => this.set(v(arguments...))
    else
      (arguments...) => this.set(v) 
