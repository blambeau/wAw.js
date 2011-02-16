{Cell} = require '../lib/cell'

test "Cell's basic contract", ->
  c = new Cell
  c.set(12)
  ok c.get() is 12

test "Cell's listener contract", ->
  local = 0
  c = new Cell
  c.add_listener (cell) ->
    local = cell.get()
  c.set(12)
  ok local is 12