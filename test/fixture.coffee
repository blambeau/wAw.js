{Brick}  = require('../src/brick')
{Cell} = require('../src/cell')
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

test "Fixture sanity", ->
  app = new FixtureApp
  app.wRun()

  ok app.wFetch('.') is app
  ok app.wFetch('/') is app
  ok app.wFetch('/c1') is app.c1

  ok app.wSet('/c1', 12) is 12
  ok app.wGet('/c1') is 12