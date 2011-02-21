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
    $.wApp.running[0].wFetch(qid)

  wGet: (qid)->
    $.wApp.running[0].wGet(qid)

  wSet: (qid, value)->
    $.wApp.running[0].wSet(qid, value)

  wListen: (sel, fn)->
    $.wApp.running[0].wListen(sel, fn)

  wUnlisten: (sel, fn)->
    $.wApp.running[0].wUnlisten(sel, fn)

  wEmit: (sel, args...)->
    $.wApp.running[0].wEmit(sel, args...)

  wConnect: (signal, slot)->
	  signal.listen(slot)

  wDisconnect: (signal, slot)->
	  signal.unlisten(slot)

  wCall: (qid, fn)->
    $.wApp.running[0].wCall(qid, fn)

