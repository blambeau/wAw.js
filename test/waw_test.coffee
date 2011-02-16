{Brick}  = require('../src/brick')
{Cell} = require('../src/cell')
{Waw}  = require('../src/waw')

class Hello extends Brick
	
	state: new Cell
	
Waw.run(new Hello)

test "Waw#fetch", ->
  ok Waw.fetch('state') instanceof Cell

test "Waw#set and Waw#get", ->
  Waw.set('state', 12) 
  ok Waw.get('state') is 12
