{Brick}  = require('wawjs/brick')
{Signal} = require('wawjs/signal')
{Cell}   = require('wawjs/cell')

b1 = new Brick
b1.b2 = new Brick
b1.b2.b3 = new Brick
b1.b2.c1 = new Cell(12)
b1.wRun()

describe "Brick", ->

  # wQid, wName, wParent & wRoot

  it "Brick#wQid", ->
    expect(b1.wQid()).toEqual '/'
    expect(b1.b2.wQid()).toEqual '/b2'
    expect(b1.b2.b3.wQid()).toEqual '/b2/b3'

  it "Brick#wName", ->
    expect(b1.wName()).toEqual '/'
    expect(b1.b2.wName()).toEqual 'b2'
    expect(b1.b2.b3.wName()).toEqual 'b3'

  it "Brick#wParent", ->
    expect(b1.wParent()).toEqual null
    expect(b1.b2.wParent()).toEqual b1
    expect(b1.b2.b3.wParent()).toEqual b1.b2

  it "Brick#wRoot", ->
    expect(b1.wRoot()).toEqual b1
    expect(b1.b2.wRoot()).toEqual b1
    expect(b1.b2.b3.wRoot()).toEqual b1

  # wFetch

  it "Brick#wFetch with relative", ->
    expect(b1.wFetch('b2')).toEqual b1.b2
    expect(b1.wFetch('b2/b3')).toEqual b1.b2.b3

  it "Brick#wFetch with absolute", ->
    expect(b1.wFetch('/')).toEqual b1
    expect(b1.wFetch('/b2/b3')).toEqual b1.b2.b3

  it "Brick#wFetch with parent references", ->
    expect(b1.b2.wFetch('..')).toEqual b1
    expect(b1.wFetch('/b2/..')).toEqual b1

  it "Brick#wFetch with sel references", ->
    expect(b1.wFetch('.')).toEqual b1
    expect(b1.b2.wFetch('.')).toEqual b1.b2
    expect(b1.wFetch('/b2/.')).toEqual b1.b2

  # Signals and signals

  it "Brick#wListen and Brick#wEmit Brick#wUnlisten", ->
    local = null
    b = new Brick
    b.hello = new Signal(b)
    listener = (name)->
      local = "Hello #{name}"

    x = b.wListen 'hello', listener
    expect(x).toEqual b

    b.wEmit 'hello', 'waw'
    expect(local).toEqual "Hello waw"
  
    b.wUnlisten 'hello', listener
    expect(x).toEqual b

    b.wEmit 'hello', 'waw2'
    expect(local).toEqual "Hello waw"
  
    x = b.wListen 'hello', listener
    b.wEmit 'hello', 'waw3'
    expect(local).toEqual "Hello waw3"

  ## wGet

  it "Brick#wGet with relative", ->
    expect(b1.wGet('b2/c1')).toEqual 12

  it "Brick#wGet with absolute", ->
    expect(b1.wGet('/b2/c1')).toEqual 12

  # wSet

  it "Brick#wSet with relative", ->
    b1.wSet('b2/c1', 15)
    expect(b1.wGet('b2/c1')).toEqual 15

  it "Brick#wGet with absolute", ->
    b1.wSet('/b2/c1', 15)
    expect(b1.wGet('/b2/c1')).toEqual 15

  # wCall

  it "Brick#wCall with relative", ->
    got = b1.wCall 'b2', ->
      this.wQid()
    expect(got).toEqual '/b2'

  it "Brick#wCall with absolute", ->
    got = b1.wCall '/b2/b3', ->
      this.wQid()
    expect(got).toEqual '/b2/b3'
