{Slot} = require '../src/slot'

test "Slot's wBind contract", ->
  s = new Slot(12)
  x = s.wBind (arg) -> arg
  ok x is s

test "Slot's wEmit contract", ->
  local = 0
  s = new Slot
  s.wBind (arg) -> local = arg * 2
  s.wEmit(12)
  ok local is 24

test "Slot's wEmit contract with multiple params", ->
  local = 0
  s = new Slot
  s.wBind (arg1, arg2) -> local = arg1 * arg2
  s.wEmit(12, 10)
  ok local is 120
