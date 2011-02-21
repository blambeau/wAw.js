{View} = require 'wawjs/view'

describe "View", ->

  it "View's url getter inline", ->
    v = new View url: 'hello'
    v.wInit()
    expect(v.url()).toEqual 'hello' 

  it "View's url getter on new line", ->
    v = new View 
      url: 'hello'
    v.wInit()
    expect(v.url()).toEqual 'hello' 

  it "View's url getter as a function", ->
    v = new View 
      url: -> 'funchello'
    v.wInit()
    expect(v.url()).toEqual 'funchello' 

  it "View's url getter as a function reliying on the view", ->
    v = new View 
      url: (passed)-> 
  	    expect(passed).toEqual v
  	    'funchello'
    v.wInit()
    expect(v.url()).toEqual 'funchello'