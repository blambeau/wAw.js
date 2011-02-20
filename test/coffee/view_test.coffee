{View} = require '../src/view'

test "View's url getter inline", ->
  v = new View url: 'hello'
  v.wInit()
  ok v.url() is 'hello' 

test "View's url getter on new line", ->
  v = new View 
    url: 'hello'
  v.wInit()
  ok v.url() is 'hello' 

test "View's url getter as a function", ->
  v = new View 
    url: -> 'funchello'
  v.wInit()
  ok v.url() is 'funchello' 

test "View's url getter as a function reliying on the view", ->
  v = new View 
    url: (passed)-> 
	    ok passed is v
	    'funchello'
  v.wInit()
  ok v.url() is 'funchello'