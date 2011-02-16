{Base} = require '../src/base'
{Slot} = require '../src/slot'

test "Base#slot", ->
  b = new Base
  h1 = b.slot('hello')
  ok (h1 instanceof Slot)
  h2 = b.slot('hello')
  ok (h1 == h2)

test "Base#has_slot}", ->
  b = new Base
  b.slot('hello')
  ok b.has_slot('hello')
  ok !b.has_slot('hello2')

test "Base#bind", ->
  b = new Base
  x = b.bind 'hello', (name) ->
    "Hello #{name}"
  ok (x == b)

test "Base#emit", ->
  local = ""
  b = new Base
  b.bind 'hello', (name) ->
    local = "Hello #{name}"
  b.emit 'hello', 'waw'
  ok ("Hello waw" == local)