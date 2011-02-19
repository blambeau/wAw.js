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
    renderData: {}
    render: (v)->
      switch v.handler()
        when 'server'
          $.ajax(url: v.url(), async: false).responseText
        when 'mustache'
          v.mustacheRender()

  ############################################################## wInit

  wInit: (parent, name) ->
    this._normalize_autorefresh()
    super
  
  ############################################################## Public API

  refresh: =>
    sel = this.selector()
    $(sel).replaceWith(this.toString())

  toString: =>
    this.render().toString()

  ############################################################## Renderers

  wCallRenderer: (text, render)=>
    call = render(text)
    call += "()" unless call[call.length - 1] == ')'
    call = "function(){ this.#{call}; }"
    call = "$.wCall('#{this.wQid()}/..', #{call});"
    console.log "Rendering |#{call}|"
    call

  mustacheRender: =>
	  tpl = this.template()
	  data = this.renderData()
	  callRenderer = this.wCallRenderer
	  data.wCall = -> callRenderer
	  Mustache.to_html(tpl, data)

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
