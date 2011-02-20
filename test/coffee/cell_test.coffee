{Cell} = require '../src/cell'
{Signal} = require '../src/signal'

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

test "Cell#wFetch", ->
  c = new Cell(12)
  ok (c.wFetch('changed') instanceof Signal)
  try
    c.wFetch('changd')
    ok false
  catch ex
    ok true