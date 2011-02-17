{FixtureApp} = require './fixture'
{Waw} = require '../src/waw'

app = new FixtureApp
Waw.run app

app.wSet('/c1', 12)
ok app.wGet('/sm') is 1
app.wSet('/c2', 12)
ok app.wGet('/sm') is 2

