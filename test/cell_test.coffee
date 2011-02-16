{Cell,View} = require '../src/cell'

test "Cell's basic contract", ->
  c = new Cell(14)
  ok c.get() is 14
  c.set(12)
  ok c.get() is 12

test "Cell's listener contract", ->
  local = 0
  c = new Cell
  c.bind "changed", (cell) ->
    local = cell.get()
  c.set(12)
  ok local is 12

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

