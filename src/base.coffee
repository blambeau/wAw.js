{Slot} = require('./slot')

#
# A base class that installs signal and slot support
#
exports.Base = class Base
	
  constructor: ->
    @slots = {}

  has_slot: (name) ->
	  x = @slots[name]
	  x?

  slot: (name) ->
    @slots[name] ?= new Slot

  bind: (s, fn) ->
    this.slot(s).bind(fn)
    this

  emit: (s, args...) ->
    this.slot(s).emit(args...)

