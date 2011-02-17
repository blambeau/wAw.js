{Brick} = require('../src/brick')
{Slot}  = require('../src/slot')
{Cell}  = require('../src/cell')

b1 = new Brick
b1.b2 = new Brick
b1.b2.b3 = new Brick
b1.b2.c1 = new Cell(12)
b1.wRun()

# wQid, wName, wParent & wRoot

test "Brick#wQid", ->
  ok b1.wQid() is '/'
  ok b1.b2.wQid() is '/b2'
  ok b1.b2.b3.wQid() is '/b2/b3'

test "Brick#wName", ->
  ok b1.wName() is '/'
  ok b1.b2.wName() is 'b2'
  ok b1.b2.b3.wName() is 'b3'

test "Brick#wParent", ->
  ok b1.wParent() is null
  ok b1.b2.wParent() is b1
  ok b1.b2.b3.wParent() is b1.b2

test "Brick#wRoot", ->
  ok b1.wRoot() is b1
  ok b1.b2.wRoot() is b1
  ok b1.b2.b3.wRoot() is b1

# wFetch

test "Brick#wFetch with relative", ->
  ok b1.wFetch('b2') is b1.b2
  ok b1.wFetch('b2/b3') is b1.b2.b3

test "Brick#wFetch with absolute", ->
  ok b1.wFetch('/') is b1
  ok b1.wFetch('/b2/b3') is b1.b2.b3

test "Brick#wFetch with parent references", ->
  ok b1.b2.wFetch('..') is b1
  ok b1.wFetch('/b2/..') is b1

test "Brick#wFetch with sel references", ->
  ok b1.wFetch('.') is b1
  ok b1.b2.wFetch('.') is b1.b2
  ok b1.wFetch('/b2/.') is b1.b2

# Signals and slots

test "Brick#wBind", ->
  b = new Brick
  b.hello = new Slot(b)
  x = b.wBind 'hello', (name) ->
    "Hello #{name}"
  ok (x == b)

test "Brick#wEmit", ->
  local = ""
  b = new Brick
  b.hello = new Slot(b)
  b.wBind 'hello', (name) ->
    local = "Hello #{name}"
  b.wEmit 'hello', 'waw'
  ok ("Hello waw" == local)

## wGet

test "Brick#wGet with relative", ->
  ok b1.wGet('b2/c1') is 12

test "Brick#wGet with absolute", ->
  ok b1.wGet('/b2/c1') is 12

# wSet

test "Brick#wSet with relative", ->
  b1.wSet('b2/c1', 15)
  ok b1.wGet('b2/c1') is 15

test "Brick#wGet with absolute", ->
  b1.wSet('/b2/c1', 15)
  ok b1.wGet('/b2/c1') is 15
