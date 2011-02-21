describe "Assumptions on String#split", ->

  it "should behave as expected on unqualified", ->
    expect('a/b/c'.split('/').length).toEqual 3
  
  it "should behave as expected on qualified", ->
    split = '/a/b/c'.split('/')
    expect(split.length).toEqual 4
    expect(split[0]).toEqual ""
  
  it "should behave as expected on root", ->
    split = '/'.split('/')
    expect(split.length).toEqual 2
    expect(split[0]).toEqual ""
    expect(split[1]).toEqual ""
  
  it "should hebave as expected on self", ->
    split = '.'.split('/')
    expect(split.length).toEqual 1
    expect(split[0]).toEqual "."
