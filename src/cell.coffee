#
# A base class that installs signal and slot support
#
this.Base = class Base
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
this.Cell = class Cell extends Base
  constructor: (@value) ->
    super

  get: -> @value

  set: (value) ->
    @value = value
    this.emit("changed")
    @value

  fetch: (sel) ->
    this.slot(sel)

#
# Defines the View class.
#
this.View = class View
  
  # Builds a View instance. Options can be:
  #
  #   selector: 
  #     The jQuery selector to access DOM element that receives
  #     view content (supports a function)
  #   url:
  #     The server side URL that will be called to get the view 
  #     content (supports a function)
  #   autorefresh:
  #     A list of slots to register to for automatically refreshing
  #     the view
  #
  constructor: (@options) ->
    
  #### Public functions

  # Returns the View options
  options: -> @options

  # Returns the current server-side URL
  url: -> this._get_opt_value 'url'

  # Returns the current selector
  selector: -> this._get_opt_value 'selector'

  # Forces the view to refresh now
  refresh: =>
    $.get this.url(), (data) =>
      $(this.selector()).html data

  #### Private functions

  # Installs the View
  _init: ->
    @options['autorefresh'] ?= []
    for l in @options['autorefresh']
      Waw.fetch(l)(this.refresh)

  # Returns the value of an option. If the options was 
  # installed as a function, it is executed to get the
  # option value
  _get_opt_value: (optkey) ->
    optvalue = @options[optkey]
    if (typeof(optvalue) is 'function')
      optvalue()
    else
      optvalue

this.App = class App

  _init: ->
    for k, v of this
      v._init() if v['_init']
    this.init();

  fetch: (sel) ->
    this[sel]

this.Waw = {
	
  run: (app) ->
    @app = app
    app._init()

  fetch: (selector) ->
    cur = @app
    for x in selector.split('/')
      cur = cur.fetch(x)
    cur

  get: (selector) ->
    this.fetch(selector).get();

  set: (selector, value) ->
	  this.fetch(selector).set(value);

}