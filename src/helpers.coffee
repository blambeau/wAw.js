exports.Helpers = class Helpers
  
  wRun: (app)->
    app.wRun()
    $.wApp = app

  wFetch: (qid)->
    $.wApp.wFetch(qid)

  wGet: (qid)->
    $.wApp.wGet(qid)

  wSet: (qid, value)->
    $.wApp.wSet(qid, value)

  wListen: (sel, fn)->
    $.wApp.wListen(sel, fn)

  wUnlisten: (sel, fn)->
    $.wApp.wUnlisten(sel, fn)

  wEmit: (sel, args...)->
    $.wApp.wEmit(sel, args...)

  wConnect: (signal, slot)->
	  signal.listen(slot)

  wDisconnect: (signal, slot)->
	  signal.unlisten(slot)

  wCall: (qid, fn)->
    $.wApp.wCall(qid, fn)

