{Cell}   = require 'wawjs/cell'
{Signal} = require 'wawjs/signal'

describe "Cell", ->

  it "Cell's basic contract", ->
    c = new Cell(14)
    expect(c.get()).toEqual 14
    c.set(12)
    expect(c.get()).toEqual 12

  it "Cell's basic w contract", ->
    c = new Cell(14)
    expect(c.wGet('.')).toEqual 14
    c.wSet('.', 12)
    expect(c.wGet('.')).toEqual 12

  it "Cell#wListen and Cell#set", ->
    c = new Cell(12)
    c.wListen "changed", (cell, oldval, newval) ->
      expect(cell).toEqual c
      expect(oldval).toEqual 12
      expect(newval).toEqual 14
    c.set(14)

  it "Cell#listen and Cell#set", ->
    c = new Cell(12)
    c.listen (cell, oldval, newval) ->
      expect(cell).toEqual c
      expect(oldval).toEqual 12
      expect(newval).toEqual 14
    c.set(14)

  it "Cell's unlisten contract", ->
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
    expect(local1).toEqual "hello"
    expect(local2).toEqual "hello"
  
    s.unlisten(f1)
    s.wEmit("changed", "hello2")
    expect(local1).toEqual "hello"
    expect(local2).toEqual "hello2"

  it "Cell#wFetch", ->
    c = new Cell(12)
    expect(c.wFetch('changed') instanceof Signal).toEqual true
    try
      c.wFetch('changd')
      expect(false).toEqual true
    catch ex
      expect(true).toEqual true