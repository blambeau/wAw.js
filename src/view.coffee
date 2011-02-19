{Brick} = require './brick'

#
# Defines the View class.
#
exports.View = class View extends Brick
  
  ############################################################## wOptions

  defaults:
    url: (v)-> 
      v.renderScope().wQid() + '/' + v.wName()
    selector: (v)->
      "#" + v.wName()
    template: (v)->
      v._template ?= $.ajax(url: v.url(), async: false).responseText
    handler:
      'server'
    renderScope: (v)->
	    v.wParent()
    renderData: {}
    partials: []
    render: (v)->
      switch v.handler()
        when 'server'
          $.ajax(url: v.url(), async: false).responseText
        when 'mustache'
          v.mustacheRender()

  ############################################################## wInit

  constructor: (opts)->
    super
    this._normalizePartials(opts)

  wInit: (parent, name) ->
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
    call = "$.wCall('#{this.renderScope().wQid()}', #{call});"
    call

  mustacheRender: =>
    # Resolve the template
    tpl = this.template()
  
    # Resolve data
    callRenderer = this.wCallRenderer      
    data = $.extend({}, this.renderScope(), {wCall: -> callRenderer}, this.renderData())
  
    # Resolve partials
    partials = {}
    for l in this.partials()
      data[l.wName()] = l.render()
      partials[l.wName()] = "{{{#{l.wName()}}}}"
  
    Mustache.to_html(tpl, data, partials)

  ############################################################## Private API

  _normalizePartials: (opts)=>
    @options['partials'] ?= []
    normalized = []
    for p in @options['partials']
      if (typeof(p) == "string")
        this[p] = this._buildPartial(p, opts)
        normalized.push(this[p])
      else
        normalized.push(p)
    @options['partials'] = normalized
    
  _buildPartial: (name, opts)=>
    override = 
      partials: []
      renderScope: (v)->
	      v.wParent().wParent()
    new View $.extend({}, opts, override)
