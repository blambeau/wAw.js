{Base} = require './base'

exports.Brick = class Brick extends Base
  
  winit: (waw, parent, name) ->
    @waw = waw
    @wname = name
    @wparent = parent
    for k, v of this
      if (k == 'waw' || k == 'wparent') 
        continue 
      else if (v? && v['winit']?)
        v.winit(waw, this, k)
    this.init() if this['init']?

  wid: ->
	  pwid = @wparent.wid()
	  if pwid == ''
		  @wname
	  else if pwid[pwid.length - 1] is '/'
      pwid + @wname
    else
      pwid + '/' + @wname

  # wQuery methods

  wFetch: (sel, index = 0) -> 
    if (sel instanceof Array)
	    selkey = sel[index]
	    mine = switch selkey
	      when '.'
	        this
	      when '..'
          @wparent
        else
          this[selkey]
      if mine?
        if (sel.length-1 == index)
          mine
        else if mine['wFetch']?
          mine.wFetch(sel, index + 1)
        else
          throw "Not a waw brick under #{sel.join('/')} (#{selkey}), unable to fetch"
      else
        throw "No such key #{sel[index]}"
    else if (sel[0] == '/')
      @waw.fetch(sel)
    else
      this.wFetch(sel.split('/'))

  wGet: (sel) ->
    fetched = this.wFetch(sel)
    if (fetched? && fetched['get']?)
      fetched.get()
    else
      throw "Not gettable #{sel}"

  wset: (sel, value) ->
    fetched = this.wFetch(sel)
    if (fetched? && fetched['set']?)
      fetched.set(value)
    else
      throw "Not settable #{sel}"