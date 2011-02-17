{Slot} = require('./slot')

exports.Brick = class Brick
  
  ############################################################## wInit and wId

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

  ############################################################## Signals and slots

  #
  # Convenient method for wFetch(sel).bind(fn)
  #
  # Throws when:
  #   - wFetch(sel) throws an error itself
  #   - No method bind() can be found on fetched component
  #
  wBind: (sel, fn) ->
    fetched = this.wFetch(sel)
    if (fetched? && fetched['bind']?)
      fetched.bind(fn)
    else
      throw "Not a bindable #{fetched}"
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