{Slot} = require('./slot')

exports.Brick = class Brick
  
  ############################################################## Construction and wInit

  # 
  # Builds a brick instance
  # 
  constructor: -> 
    @slots = {}

  # 
  # Initializes the brick and all its children recursively.
  #
  # Parameters: 
  #   - waw: instance of the w@w engine to refer to for 
  #          resolving qualified queries
  #   - parent: the parent brick in the tree
  #   - name: name of the brick as used in the parent
  #
  wInit: (waw, parent, name) ->
    @waw = waw
    @wname = name
    @wparent = parent
    for k, v of this
      if (k == 'waw' || k == 'wparent') 
        continue 
      else if (v? && v['wInit']?)
        v.wInit(waw, this, k)
    this.init() if this['init']?

  ############################################################## Signals and slots

  #
  # Checks if the brick has a given slot.
  #
  # Parameters:
  #   - name: a slot name
  #
  has_slot: (name) ->
	  x = @slots[name]
	  x?

  #
  # Returns a slot by name, creating it is required
  #
  # Parameters:
  #   - name: a slot name
  #
  slot: (name) ->
    @slots[name] ?= new Slot

  #
  # Convenient method for slot(name).bind(fn)
  #
  # Parameters:
  #   - name: a slot name
  #   - fn: a function to bind to the slot
  #
  bind: (name, fn) ->
    this.slot(name).bind(fn)
    this

  # 
  # Convenient method for slot(name).emit(args...)
  # 
  # Parameters:
  #   - name: a slot name
  #   - args: arguments of the signal emission
  #
  emit: (name, args...) ->
    this.slot(name).emit(args...)

  ############################################################## wQuery methods

  # 
  # Returns brick's qualified identifier. 
  #
  wQid: ->
	  pwQid = @wparent.wQid()
	  if pwQid == ''
		  @wname
	  else if pwQid[pwQid.length - 1] is '/'
      pwQid + @wname
    else
      pwQid + '/' + @wname

  # 
  # Fetches and returns a component in the w@w tree.
  #
  # Parameters: 
  #   - sel: a query selector (i.e. 'a/tree/selector')
  #
  # Throws when:
  #   - a component fetched along the query is not a brick (unless
  #     the last one).
  #   - the component cannot be found
  # 
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

  #
  # Convention method for wFetch(sel).get()
  #
  # Throws when:
  #   - wFetch(sel) throws an error itself
  #   - No method get() can be found on fetched component
  #
  wGet: (sel) ->
    fetched = this.wFetch(sel)
    if (fetched? && fetched['get']?)
      fetched.get()
    else
      throw "Not gettable #{sel}"

  #
  # Convention method for wFetch(sel).set(value)
  #
  # Throws when:
  #   - wFetch(sel) throws an error itself
  #   - No method set() can be found on fetched component
  #
  wSet: (sel, value) ->
    fetched = this.wFetch(sel)
    if (fetched? && fetched['set']?)
      fetched.set(value)
    else
      throw "Not settable #{sel}"