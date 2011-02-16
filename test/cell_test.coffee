waw = require '../lib/waw'

test "Cell's basic contract", ->
  c = new waw.Cell
  c.set(12)
  ok c.get() is 12

test "Cell's listener contract", ->
  local = 0
  c = new waw.Cell
  c.add_listener (cell) ->
    local = cell.get()
  c.set(12)
  ok local is 12