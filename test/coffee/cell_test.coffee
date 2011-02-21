{Cell} = require '../../src/wawjs/cell'
{Signal} = require '../../src/wawjs/signal'

test "Cell's basic contract", ->
  c = new Cell(14)
  ok c.get() is 14
  c.set(12)
  ok c.get() is 12

test "Cell's basic w contract", ->
  c = new Cell(14)
  ok c.wGet('.') is 14
  c.wSet('.', 12)
  ok c.wGet('.') is 12

test "Cell#wListen and Cell#set", ->
  c = new Cell(12)
  c.wListen "changed", (cell, oldval, newval) ->
    ok (cell is c && oldval is 12 && newval is 14)
  c.set(14)

test "Cell#listen and Cell#set", ->
  c = new Cell(12)
  c.listen (cell, oldval, newval) ->
    ok (cell is c && oldval is 12 && newval is 14)
  c.set(14)

test "Cell's unlisten contract", ->
  s = new Cell
  local1 = null
  local2 = null
  f1 = (arg)->
    local1 = arg
  f2 = (arg)->
    local2 = arg
    
  s.listen(f1)
  s.listen(f2)
  s.wEmit("changed", "hello")
  ok local1 is "hello"
  ok local2 is "hello"
  
  s.unlisten(f1)
  s.wEmit("changed", "hello2")
  ok local1 is "hello"
  ok local2 is "hello2"

test "Cell#wFetch", ->
  c = new Cell(12)
  ok (c.wFetch('changed') instanceof Signal)
  try
    c.wFetch('changd')
    ok false
  catch ex
    ok true