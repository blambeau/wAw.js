{Brick} = require('../src/brick')
{Waw}   = require('../src/waw')

b1 = new Brick
b1.b2 = new Brick
b1.b2.b3 = new Brick
Waw.run b1

test "Brick#winit", ->
  b1.winit(Waw, Waw, '/')
  ok b1['waw'] is Waw
  ok b1.b2['wparent'] is b1
  ok b1.b2['waw'] is Waw
  ok b1.b2.b3['wparent'] is b1.b2
  ok b1.b2.b3['waw'] is Waw

test "Brick#wfetch with relative", ->
  ok b1.wfetch('b2') is b1.b2
  ok b1.wfetch('b2/b3') is b1.b2.b3

test "Brick#wfetch with absolute", ->
  ok b1.wfetch('/b2/b3') is b1.b2.b3