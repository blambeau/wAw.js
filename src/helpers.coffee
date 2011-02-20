exports.Helpers = class Helpers
  
  wApp: {
    onReady: []
    running: []
    start: ->
      for fn in $.wApp.onReady
        $.wApp.running.push(fn())
    ready: (fn)-> 
      $.wApp.onReady.push(fn)
  }
  
  wRun: (app)->
    app.wRun()
    app

  wFetch: (qid)->
    $.wApps[0].wFetch(qid)

  wGet: (qid)->
    $.wApps[0].wGet(qid)

  wSet: (qid, value)->
    $.wApps[0].wSet(qid, value)

  wListen: (sel, fn)->
    $.wApps[0].wListen(sel, fn)

  wUnlisten: (sel, fn)->
    $.wApps[0].wUnlisten(sel, fn)

  wEmit: (sel, args...)->
    $.wApps[0].wEmit(sel, args...)

  wConnect: (signal, slot)->
	  signal.listen(slot)

  wDisconnect: (signal, slot)->
	  signal.unlisten(slot)

  wCall: (qid, fn)->
    $.wApps[0].wCall(qid, fn)

