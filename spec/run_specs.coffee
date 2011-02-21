require.paths.push __dirname + "/../../jasmine-node"
require.paths.push __dirname + "/../src"

jasmine = require('jasmine-node')

for key in jasmine
  global[key] = jasmine[key]

isVerbose = false
showColors = true

folder = __dirname + '/wawjs/coffee'
logger = (runner, log)->
  process.exit runner.results().failedCount

jasmine.executeSpecsInFolder folder, logger, isVerbose, showColors, "_spec.coffee$"
