{Slot} = require '../src/slot'

test "Slot's bind contract", ->
  s = new Slot(12)
  x = s.bind (arg) -> arg
  ok x is s

test "Slot's emit contract", ->
  local = 0
  s = new Slot
  s.bind (arg) -> local = arg * 2
  s.emit(12)
  ok local is 24

test "Slot's emit contract with multiple params", ->
  local = 0
  s = new Slot
  s.bind (arg1, arg2) -> local = arg1 * arg2
  s.emit(12, 10)
  ok local is 120
