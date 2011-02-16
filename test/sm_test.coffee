{FixtureApp} = require './fixture'
{Waw} = require '../src/waw'

app = new FixtureApp
Waw.run app

app.wset('/c1', 12)
ok app.wget('/sm') is 1
app.wset('/c2', 12)
ok app.wget('/sm') is 2

