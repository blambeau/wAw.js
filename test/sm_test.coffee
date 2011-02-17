{FixtureApp} = require './fixture'

app = new FixtureApp
app.wRun()

app.wSet('/c1', 12)
ok app.wGet('/sm') is 1
app.wSet('/c2', 12)
ok app.wGet('/sm') is 2
