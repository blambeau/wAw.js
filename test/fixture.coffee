{Brick}  = require('../src/brick')
{Cell} = require('../src/cell')
{Waw}  = require('../src/waw')
{SM}  = require('../src/sm')

exports.FixtureApp = class FixtureApp extends Brick
  constructor: ->

    # A first cell
    @c1 = new Cell("c1")

    # A second one
    @c2 = new Cell("c2")

    # A third one
    @c3 = new Cell(0)

    # A State Machine
    @sm = new SM {'/c1': 1, '/c2': 2}