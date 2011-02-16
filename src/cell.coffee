#
# A base class that installs signal and slot support
#
exports.Base = class Base
  constructor: ->
    @listeners = {}

  emit: (slot) ->
    @listeners[slot] ?= []
    for l in @listeners[slot]
      l(this)
    this

  bind: (slot, fn) ->
    @listeners[slot] ?= []
    @listeners[slot].push(fn)
    this

  slot: (name) ->
    (fn) => this.bind(name, fn)

#
# A Memory/State Cell supporting a 'changed' slot
#
exports.Cell = class Cell extends Base
  constructor: (@value) ->
    super

  get: -> @value

  set: (value) ->
    @value = value
    this.emit("changed")
    @value

  fetch: (sel) ->
    this.slot(sel)
