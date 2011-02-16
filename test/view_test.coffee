{View} = require '../src/view'

test "View's url getter (1)", ->
  v = new View url: 'hello'
  ok v.url() is 'hello' 

test "View's url getter (2)", ->
  v = new View 
    url: 'hello'
  ok v.url() is 'hello' 

test "View's url getter (3)", ->
  v = new View 
    url: -> 'funchello'
  ok v.url() is 'funchello' 


