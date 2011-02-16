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

  # Installs the View
  init: ->
    @options['autorefresh'] ?= []
    for l in @options['autorefresh']
      this.wfetch(l).bind(this.refresh)

  # Returns the value of an option. If the options was 
  # installed as a function, it is executed to get the
  # option value
  _get_opt_value: (optkey) ->
    optvalue = @options[optkey]
    if (typeof(optvalue) is 'function')
      optvalue.apply(this)
    else
      optvalue
