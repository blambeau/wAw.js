{Brick} = require './brick'

#
# Defines the View class.
#
exports.View = class View extends Brick
  
  defaults:
    url: (v)-> 
      v.wQid()
    selector: (v)->
      "#" + v.wName()
    template: (v)->
      v._template ?= $.ajax(url: v.url(), async: false).responseText
    render: (v)->
      $.ajax(url: v.url(), async: false).responseText

  constructor: (opts) ->
	  if $?
      @options = $.extend({}, View.prototype.defaults, opts)
    else
      @options = opts
    
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
