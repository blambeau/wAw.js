global.Nib = require('nib').Nib

describe "Nib", ->

  it 'should support register / start / query scenario', ->
    ran = null
    fn = ()->
      ran = "Hello world!"
      
    # Mark it as ready
    Nib.ready(fn)

    # Start it now
    Nib.start()
    expect( ran ).toEqual "Hello world!"
    
    # Verify that it is running
    expect(Nib.isRunning("Hello world!")).toEqual true
    
  it 'should support embedding .js applications in browser', ->
    require('./fixture')
    
    # Require it
    fix = Nib.require('fixture')
    expect(fix.App).toBeDefined
    expect(fix.Dependent).toBeDefined
    
    # Check it
    expect((new fix.App).say_hello()).toEqual "Hello from App"
    expect((new fix.Dependent).say_hello()).toEqual "Hello from Dependent"
