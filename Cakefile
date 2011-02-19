fs            = require 'fs'
path          = require 'path'
{spawn, exec} = require 'child_process'
coffee        = require 'coffee-script'

# ANSI Terminal Colors.
bold  = '\033[0;1m'
red   = '\033[0;31m'
green = '\033[0;32m'
reset = '\033[0m'

# Library version
VERSION = "1.0.0"

# Log a message with a color.
log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

# Handle error and kill the process.
onerror = (err)->
  if err
    process.stdout.write "#{red}#{err.stack}#{reset}\n"
    process.exit -1

# Build process

build = (callback)->
  log "Compiling CoffeeScript to JavaScript ...", green
  exec "rm -rf lib && coffee -c -l -o lib src", (err, stdout)->
    callback err
task "build", "Compile CoffeeScript to JavaScript", -> build onerror

dist = (callback)->
  target = "dist/waw-#{VERSION}.js"
  log "Compiling #{target}", green

  # compile .coffee files in order
  order = fs.readFileSync("src/dependencies").toString().split("\n")
  exec "coffee -p -c -l -j src/#{order.join(' src/')}", (err, stdout)->
    callback err

    code = ""
    code += fs.readFileSync("dist/browser.pre.js")
    code += stdout.toString()
    code += fs.readFileSync("dist/browser.post.js")

    fs.writeFileSync target, code
task "dist", "Building waw.js distribution", -> dist onerror

clean = (callback)->
  exec "rm -rf lib", callback
task "clean", "Remove temporary files and such", -> clean onerror



# Tests

runTests = ->
  startTime   = Date.now()
  currentFile = null
  passedTests = 0
  failures    = []

  # make "global" reference available to tests
  global.global = global

  # Mix in the assert module globally, to make it available for tests.
  addGlobal = (name, func) ->
    global[name] = ->
      passedTests += 1
      func arguments...

  addGlobal name, func for name, func of require 'assert'

  # Convenience aliases.
  global.eq = global.strictEqual

  # Our test helper function for delimiting different test cases.
  global.test = (description, fn) ->
    try
      fn.test = {description, currentFile}
      fn.call(fn)
    catch e
      e.description = description if description?
      e.source      = fn.toString() if fn.toString?
      failures.push file: currentFile, error: e

  # A recursive functional equivalence helper; uses egal for testing equivalence.
  # See http://wiki.ecmascript.org/doku.php?id=harmony:egal
  arrayEqual = (a, b) ->
    if a is b
      # 0 isnt -0
      a isnt 0 or 1/a is 1/b
    else if a instanceof Array and b instanceof Array
      return no unless a.length is b.length
      return no for el, idx in a when not arrayEqual el, b[idx]
      yes
    else
      # NaN is NaN
      a isnt a and b isnt b

  global.arrayEq = (a, b, msg) -> ok arrayEqual(a,b), msg

  # When all the tests have run, collect and print errors.
  # If a stacktrace is available, output the compiled function source.
  process.on 'exit', ->
    time = ((Date.now() - startTime) / 1000).toFixed(2)
    message = "passed #{passedTests} tests in #{time} seconds#{reset}"
    return log(message, green) unless failures.length
    log "failed #{failures.length} and #{message}", red
    for fail in failures
      {error, file}      = fail
      jsFile             = file.replace(/\.coffee$/,'.js')
      match              = error.stack?.match(new RegExp(fail.file+":(\\d+):(\\d+)"))
      [match, line, col] = match if match
      log "\n  #{error.toString()}", red
      log "  #{error.description}", red if error.description
      log "  #{jsFile}: line #{line or 'unknown'}, column #{col or 'unknown'}", red
      console.log "  #{error.source}" if error.source

  # Run every test in the `test` folder, recording failures.
  fs.readdir 'test', (err, files) ->
    files.forEach (file) ->
      return unless file.match(/\.coffee$/i)
      filename = path.join 'test', file
      fs.readFile filename, (err, code) ->
        currentFile = filename
        try
          coffee.run code.toString(), {filename}
        catch e
          failures.push file: currentFile, error: e
task 'test', 'run the CoffeeScript language test suite', ->
  runTests require('./src/cell')
