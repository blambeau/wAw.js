{Cell} = require '../src/cell'

test "Cell's basic contract", ->
  c = new Cell(14)
  ok c.get() is 14
  c.set(12)
  ok c.get() is 12

test "Cell's listener contract", ->
  local = 0
  c = new Cell
  c.bind "changed", (cell) ->
    local = cell.get()
  c.set(12)
  ok local is 12
