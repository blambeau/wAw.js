{Signal} = require('wawjs/signal')

describe "Signal", ->

  it 'should take the brick at construction', ->
    s = new Signal('brick')
    expect(s.brick).toEqual 'brick'
  
  it 'should support listening to it', ->
    s = new Signal
    local = null
    s.listen (arg)->
      local = arg
    s.emit(12)
    expect(local).toEqual 12
    
  it 'should support unlistening to it', ->
    s = new Signal
    local1 = null
    local2 = null
    f1 = (arg)->
      local1 = arg
    f2 = (arg)->
      local2 = arg
    
    s.listen(f1)
    s.listen(f2)
    s.emit("hello")
    expect(local1).toEqual "hello"
    expect(local2).toEqual "hello"
  
    s.unlisten(f1)
    s.emit("hello2")
    expect(local1).toEqual "hello"
    expect(local2).toEqual "hello2"

  it 'should support giving args to emit', ->
    local = 0
    s = new Signal
    s.listen (who, mult)-> 
      local = who * mult
    s.emit(12, 2)
    expect(local).toEqual 24
  