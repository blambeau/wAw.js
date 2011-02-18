{Brick} = require './brick'

#
# Defines the View class.
#
exports.View = class View extends Brick
  
  ############################################################## wOptions

  defaults:
    url: (v)-> 
      v.wQid()
    selector: (v)->
      "#" + v.wName()
    template: (v)->
      v._template ?= $.ajax(url: v.url(), async: false).responseText
    handler:
      'server'
    render: (v)->
      switch v.handler()
        when 'server'
          $.ajax(url: v.url(), async: false).responseText
        when 'mustache'
          Mustache.to_html(v.template(), v.renderData())

  ############################################################## wInit

  wInit: (parent, name) ->
    this._normalize_autorefresh()
    super
  
  ############################################################## Public API

  refresh: =>
    sel = this.selector()
    $(sel).html(this.toString())

  toString: =>
    this.render().toString()

  ############################################################## Private API

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
