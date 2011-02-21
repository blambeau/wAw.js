{SM} = require('wawjs/sm')
{FixtureApp} = require('./fixture')

app = new FixtureApp
app.wRun()

describe "SM", ->
  
  it 'should follow c1 and c2', ->
    app.wSet('/c1', 12)
    expect(app.wGet('/sm')).toEqual 1
    app.wSet('/c2', 122)
    expect(app.wGet('/sm')).toEqual 122
