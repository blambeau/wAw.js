{Brick}  = require('wawjs/brick')
{Cell}   = require('wawjs/cell')
{SM}     = require('wawjs/sm')

exports.FixtureApp = class FixtureApp extends Brick
  constructor: ->

    # A first cell
    @c1 = new Cell("c1")

    # A second one
    @c2 = new Cell("c2")

    # A third one
    @c3 = new Cell(0)

    # A State Machine
    @sm = new SM { 
      '/c1': 1, 
      '/c2': (cell, oldval, newval) -> newval
    }
