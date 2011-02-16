{View} = require '../src/view'

test "View's url getter inline", ->
  v = new View url: 'hello'
  ok v.url() is 'hello' 

test "View's url getter on new line", ->
  v = new View 
    url: 'hello'
  ok v.url() is 'hello' 

test "View's url getter as an object responding to wget", ->
  o = { wget: -> "objhello" }
  v = new View 
    url: o
  ok v.url() is 'objhello' 

test "View's url getter as a function", ->
  v = new View 
    url: -> 'funchello'
  ok v.url() is 'funchello' 



