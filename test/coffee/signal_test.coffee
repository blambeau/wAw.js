{Signal} = require '../src/signal'

test "Signal's constructor", ->
  s = new Signal
  ok !s.brick?
  s = new Signal(12)
  ok s.brick is 12

test "Signal's listen contract", ->
  s = new Signal
  x = s.listen (arg) -> arg
  ok x is s

test "Signal's listen contract", ->
  s = new Signal
  x = s.listen (arg) -> arg
  ok x is s

test "Signal's emit contract", ->
  local = 0
  s = new Signal
  s.listen (arg) -> local = arg * 2
  s.emit(12)
  ok local is 24

test "Signal's emit contract with multiple params", ->
  local = 0
  s = new Signal
  s.listen (arg1, arg2) -> local = arg1 * arg2
  s.emit(12, 10)
  ok local is 120
