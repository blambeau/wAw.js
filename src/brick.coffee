{Slot} = require('./slot')

exports.Brick = class Brick
  
  ############################################################## Construction and wInit

  # 
  # Builds a brick instance
  # 
  constructor: -> 
    @wSlots = {}

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
    @wAw = waw
    @wName = name
    @wParent = parent
    for k, v of this
      if (k == 'wAw' || k == 'wParent') 
        continue 
      else if (v? && v['wInit']?)
        v.wInit(waw, this, k)
    this.init() if this['init']?

  ############################################################## Signals and wSlots

  #
  # Returns a wSlot by name, creating it is required
  #
  # Parameters:
  #   - name: a slot name
  #
  wSlot: (name) ->
    @wSlots[name] ?= new Slot(this)

  #
  # Convenient method for wSlot(name).bind(fn)
  #
  # Parameters:
  #   - name: a slot name
  #   - fn: a function to bind to the slot
  #
  wBind: (name, fn) ->
    this.wSlot(name).bind(fn)
    this

  # 
  # Convenient method for wSlot(name).emit(args...)
  # 
  # Parameters:
  #   - name: a slot name
  #   - args: arguments of the signal emission
  #
  wEmit: (name, args...) ->
    this.wSlot(name).emit(args...)

  ############################################################## wQuery methods

  # 
  # Returns brick's qualified identifier. 
  #
  wQid: ->
	  pwQid = @wParent.wQid()
	  if pwQid == ''
		  @wName
	  else if pwQid[pwQid.length - 1] is '/'
      pwQid + @wName
    else
      pwQid + '/' + @wName

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
	  # recursive part
    if (sel instanceof Array)
	    selkey = sel[index]
      
      # make one step by resolving my part
	    mine = switch selkey
	      when '.'
	        this
	      when '..'
          @wParent
        else
          this[selkey]

      # handle substeps
      if mine?
        if (sel.length-1 == index)
          mine
        else if mine['wFetch']?
          mine.wFetch(sel, index + 1)
        else
          throw "Not a waw brick under #{sel.join('/')} (#{selkey}), unable to fetch"
      else
        throw "No such key #{sel[index]}"

    # end user part
    else if (sel[0] == '/')
      @wAw.fetch(sel)
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