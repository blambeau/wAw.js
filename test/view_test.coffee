{View} = require '../src/view'

test "View's url getter inline", ->
  v = new View url: 'hello'
  ok v.url() is 'hello' 

test "View's url getter on new line", ->
  v = new View 
    url: 'hello'
  ok v.url() is 'hello' 

test "View's url getter as an object responding to wGet", ->
  o = { wGet: -> "objhello" }
  v = new View 
    url: o
  ok v.url() is 'objhello' 

test "View's url getter as a function", ->
  v = new View 
    url: -> 'funchello'
  ok v.url() is 'funchello' 

test "View#_normalize_autorefresh", ->
  v = new View
  #
  ar = v._normalize_autorefresh()
  ok (ar instanceof Array && ar.length == 0)
  #
  ar = v._normalize_autorefresh('hello')
  ok (ar instanceof Array && ar.length == 1 && ar[0] == 'hello')
  #
  ar = v._normalize_autorefresh(['hello'])
  ok (ar instanceof Array && ar.length == 1 && ar[0] == 'hello')


