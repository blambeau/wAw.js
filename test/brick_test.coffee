{Brick} = require('../src/brick')
{Cell}  = require('../src/cell')
{Waw}   = require('../src/waw')

b1 = new Brick
b1.b2 = new Brick
b1.b2.b3 = new Brick
b1.b2.c1 = new Cell(12)
Waw.run b1

# winit

test "Brick#winit", ->
  b1.winit(Waw, Waw, '/')
  ok b1['waw'] is Waw
  ok b1.b2['wparent'] is b1
  ok b1.b2['waw'] is Waw
  ok b1.b2.b3['wparent'] is b1.b2
  ok b1.b2.b3['waw'] is Waw

# wfetch

test "Brick#wfetch with relative", ->
  ok b1.wfetch('b2') is b1.b2
  ok b1.wfetch('b2/b3') is b1.b2.b3

test "Brick#wfetch with absolute", ->
  ok b1.wfetch('/b2/b3') is b1.b2.b3

test "Brick#wfetch with parent references", ->
  ok b1.b2.wfetch('..') is b1

## wget

test "Brick#wget with relative", ->
  ok b1.wget('b2/c1') is 12

test "Brick#wget with absolute", ->
  ok b1.wget('/b2/c1') is 12

# wset

test "Brick#wset with relative", ->
  b1.wset('b2/c1', 15)
  ok b1.wget('b2/c1') is 15

test "Brick#wget with absolute", ->
  b1.wset('/b2/c1', 15)
  ok b1.wget('/b2/c1') is 15
