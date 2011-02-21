{Signal} = require '../../src/wawjs/signal'

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

test "Signal's unlisten contract", ->
  s = new Signal
  local1 = null
  local2 = null
  f1 = (arg)->
    local1 = arg
  f2 = (arg)->
    local2 = arg
    
  s.listen(f1)
  s.listen(f2)
  s.emit("hello")
  ok local1 is "hello"
  ok local2 is "hello"
  
  s.unlisten(f1)
  s.emit("hello2")
  ok local1 is "hello"
  ok local2 is "hello2"

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
