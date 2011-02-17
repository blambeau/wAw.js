{Brick} = require('../src/brick')
{Slot}  = require('../src/slot')
{Cell}  = require('../src/cell')
{Waw}   = require('../src/waw')

b1 = new Brick
b1.b2 = new Brick
b1.b2.b3 = new Brick
b1.b2.c1 = new Cell(12)
Waw.run b1

# wInit

test "Brick#wInit", ->
  b1.wInit(Waw, Waw, '/')
  ok b1['waw'] is Waw
  ok b1.b2['wparent'] is b1
  ok b1.b2['waw'] is Waw
  ok b1.b2.b3['wparent'] is b1.b2
  ok b1.b2.b3['waw'] is Waw

# Signals and slots

test "Brick#slot", ->
  b = new Brick
  h1 = b.slot('hello')
  ok (h1 instanceof Slot)
  h2 = b.slot('hello')
  ok (h1 == h2)

test "Brick#has_slot}", ->
  b = new Brick
  b.slot('hello')
  ok b.has_slot('hello')
  ok !b.has_slot('hello2')

test "Brick#bind", ->
  b = new Brick
  x = b.bind 'hello', (name) ->
    "Hello #{name}"
  ok (x == b)

test "Brick#emit", ->
  local = ""
  b = new Brick
  b.bind 'hello', (name) ->
    local = "Hello #{name}"
  b.emit 'hello', 'waw'
  ok ("Hello waw" == local)


# wQid

test "Brick#wQid", ->
  ok b1.wQid() is '/'
  ok b1.b2.wQid() is '/b2'
  ok b1.b2.b3.wQid() is '/b2/b3'

# wFetch

test "Brick#wFetch with relative", ->
  ok b1.wFetch('b2') is b1.b2
  ok b1.wFetch('b2/b3') is b1.b2.b3

test "Brick#wFetch with absolute", ->
  ok b1.wFetch('/b2/b3') is b1.b2.b3

test "Brick#wFetch with parent references", ->
  ok b1.b2.wFetch('..') is b1

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
