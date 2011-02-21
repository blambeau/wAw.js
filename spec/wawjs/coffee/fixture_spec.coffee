{FixtureApp} = require('./fixture')

describe "Fixture", ->

  it "should be sane after construction", ->
    app = new FixtureApp
    app.wRun()

    expect(app.wFetch('.')).toEqual app
    expect(app.wFetch('/')).toEqual app
    expect(app.wFetch('/c1')).toEqual app.c1

    expect(app.wSet('/c1', 12)).toEqual 12
    expect(app.wGet('/c1')).toEqual 12