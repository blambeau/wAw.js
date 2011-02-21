{Signal} = require('wawjs/signal')

describe "Signal", ->
  
  it 'should support listening to it', ->
    s = new Signal
    local = null
    s.listen (arg)->
      local = arg
    s.emit(12)
    expect(local).toEqual 12