exports.App = class App

  _init: ->
    for k, v of this
      v._init() if v['_init']
    this.init() if this['init']

  fetch: (sel) ->
    this[sel]

