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

  init: ->
    @options['autorefresh'] = this._normalize_autorefresh(@options['autorefresh'])
    for l in @options['autorefresh']
	    if (typeof(l) == "string")
        l = this.wfetch(l) 
      l.bind(this.refresh)

  _normalize_autorefresh: (ar) ->
    ar = [] unless ar?
    if !(ar instanceof Array)
	    ar = [ ar ]
    ar

  # Returns the value of an option. If the options was 
  # installed as a function, it is executed to get the
  # option value
  _get_opt_value: (optkey) ->
    optvalue = @options[optkey]
    switch typeof(optvalue)
      when 'function'
  	    optvalue()
      when 'string'
        optvalue
      else 
        if optvalue? && optvalue['wget']?
          optvalue.wget()
        else if optvalue?
          optvalue.toString()
        else
	        optvalue
      
