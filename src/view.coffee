{Brick} = require './brick'

#
# Defines the View class.
#
exports.View = class View extends Brick
  
  # Builds a View instance. Options can be:
  #
  #   selector: 
  #     The jQuery selector to access DOM element that receives
  #     view content (supports a function)
  #   url:
  #     The server side URL that will be called to get the view 
  #     content (supports a function)
  #   autorefresh:
  #     A list of signals to register to for automatically refreshing
  #     the view
  #
  constructor: (@options) ->
    
  refresh: =>
    sel = this.selector()
    $(sel).html(this.toString())

  toString: =>
    this.render().toString()

  #### Private functions

  wInit: (parent, name) ->
    this._normalize_autorefresh()
    for k,v of @options
      f = this._build_function(v)
      this[k] = f
  
  _build_function: (v) ->
    if typeof(v) == 'function'
      self = this
      -> v(self)
    else
      -> v

  _normalize_autorefresh: ->
    ar = @options['autorefresh']
    ar = [] unless ar?
    ar = [ ar ] if !(ar instanceof Array)
    for l in ar
      if (typeof(l) == "string")
        this.wListen(l, this.refresh) 
      else
        l.listen(this.refresh)
    @options['autorefresh'] = ar

  # Returns the value of an option. If the options was 
  # installed as a function, it is executed to get the
  # option value
  _get_opt_value: (optkey) ->
    optvalue = @options[optkey]
    switch typeof(optvalue)
      when 'function'
        optvalue(this)
      when 'string'
        optvalue
      else 
        if optvalue? && optvalue['get']?
          optvalue.get()
        else if optvalue?
          optvalue.toString()
        else
          optvalue
      
