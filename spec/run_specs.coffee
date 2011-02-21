require.paths.push __dirname + "/../../jasmine-node"
require.paths.push __dirname + "/../src"
require.paths.push __dirname + "/../src/nib"

jasmine = require('jasmine-node')

for key in jasmine
  global[key] = jasmine[key]

isVerbose = false
showColors = true

logger = (runner, log)->
  process.exit runner.results().failedCount

# Execute wawjs's specs
folder = __dirname + '/wawjs/coffee'
jasmine.executeSpecsInFolder folder, logger, isVerbose, showColors, "_spec.coffee$"

# Execute nib's specs
folder = __dirname + '/nib'
jasmine.executeSpecsInFolder folder, logger, isVerbose, showColors, "_spec.coffee$"
