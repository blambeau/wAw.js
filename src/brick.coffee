{Signal} = require('./signal')

exports.Brick = class Brick
  
  ############################################################## wInit and wId

  constructor: (opts = {})->
    try
      defs = this.__proto__.constructor.prototype.defaults
      @options = $.extend({}, defs, opts)
    catch err
      @options = opts

  # 
  # Initializes the brick and all its children recursively. 
  #
  # This function is not intended to be overriden. Please provide all 
  # user-defined initializations in a wInit method that will be called
  # at end of tree initialization provided by this method.
  #
  # Parameters: 
  #   - waw: instance of the w@w engine to refer to for 
  #          resolving qualified queries
  #   - parent: the parent brick in the tree
  #   - name: name of the brick as used in the parent
  #
  _wInit: (parent, name) ->
    # set parent, root and name
    if parent?
      @_wRoot = parent.wRoot()
      @_wParent = parent
    else
      @_wRoot = this
      @_wParent = null
    @_wName = name

    # set qualified name
    @_wQid = if @_wParent is null
      '/'
    else 
      pwQid = @_wParent.wQid()
      if pwQid is '/'
        pwQid + @_wName
      else
        pwQid + '/' + @_wName

    # # propagate to children now
    for k, v of this
      if (k[0] == '_') 
        continue 
      else if (v? && v['_wInit']?)
        v._wInit(this, k)
      else if (v? && v['wInit']?)
        v.wInit(this, k)
    
    # User defined initialization
    this.wInit(parent, k) if this['wInit']?

  ############################################################## Private API

  wInit: (parent, name) ->
    for k,v of @options
      f = this._build_function(v)
      this[k] = f

  _build_function: (v) ->
    if typeof(v) == 'function'
      self = this
      -> v(self)
    else
      -> v

  ############################################################## Public API

  #
  # Returns brick unqualified name
  #
  wName: ->
    @_wName

  #
  # Returns brick parent, null if the brick is root of the tree
  #
  wParent: ->
    @_wParent

  #
  # Returns root of the brick tree 
  #
  wRoot: ->
    @_wRoot

  # 
  # Returns brick's qualified identifier. 
  #
  wQid: ->
    @_wQid

  #
  # Runs the brick. 
  #
  wRun: ->
    this._wInit(null, '/')

  ############################################################## wFetch

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
        when '/'
          @_wRoot
        when '.'
          this
        when '..'
          @_wParent
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
    else if sel == '/'
      @_wRoot
    else
      split = sel.split('/')
      split[0] = '/' if split[0] == ""
      this.wFetch(split, 0)

  ############################################################## wGet and wSet

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

  ############################################################## Signals

  #
  # Convenient method for wFetch(sel).listen(fn)
  #
  # Throws when:
  #   - wFetch(sel) throws an error itself
  #   - No method listen() can be found on fetched component
  #
  wListen: (sel, fn) ->
    fetched = this.wFetch(sel)
    if (fetched? && fetched['listen']?)
      fetched.listen(fn)
    else
      throw "Not a listenable #{fetched}"
    this
    
  #
  # Convenient method for wFetch(sel).unlisten(fn)
  #
  # Throws when:
  #   - wFetch(sel) throws an error itself
  #   - No method unlisten() can be found on fetched component
  #
  wUnlisten: (sel, fn)->
    fetched = this.wFetch(sel)
    if (fetched? && fetched['unlisten']?)
      fetched.unlisten(fn)
    else
      throw "Not a listenable #{fetched}"
    this

  # 
  # Convenient method for wFetch(sel).emit(args...)
  # 
  # Throws when:
  #   - wFetch(sel) throws an error itself
  #   - No method emit() can be found on fetched component
  #
  wEmit: (sel, args...) ->
    fetched = this.wFetch(sel)
    if (fetched? && fetched['emit']?)
      fetched.emit(args...)
    else
      throw "Not an emittable #{fetched}"
    this

  ############################################################## Calling

  # 
  # Executes fn in the context of the object fetched with wFetch(sel)
  #
  # Throws when:
  #   - wFetch(sel) throws an error itself
  #
  wCall: (sel, fn) ->
    fetched = this.wFetch(sel)
    if fetched?
      return fn.apply(fetched)
    else
      throw "Not found #{sel}"
