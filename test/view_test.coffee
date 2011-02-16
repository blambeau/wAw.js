{View} = require '../src/view'

test "View's url getter inline", ->
  v = new View url: 'hello'
  ok v.url() is 'hello' 

test "View's url getter on new line", ->
  v = new View 
    url: 'hello'
  ok v.url() is 'hello' 

test "View's url getter as a function", ->
  v = new View 
    url: -> 'funchello'
  ok v.url() is 'funchello' 

test "View's url getter as a function that uses this", ->
  v = new View 
    url: -> this
  ok v.url() is v



