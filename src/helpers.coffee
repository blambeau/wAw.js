exports.Helpers = class Helpers
  
  wRun: (app)->
    app.wRun()
    $.wApp = app

  wFetch: (qid)->
    $.wApp.wFetch(qid)

  wGet: (qid)->
    $.wApp.wGet(qid)

  wSet: (qid, value)->
    $.wApp.wSet(qid, fn)

  wListen: (sel, fn)->
    $.wApp.wListen(sel, fn)

  wEmit: (sel, args...)->
    $.wApp.wEmit(sel, args...)

  wCall: (qid, fn)->
    $.wApp.wCall(qid, fn)

