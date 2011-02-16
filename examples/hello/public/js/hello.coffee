class Hello
  constructor: ->
    @current = new Cell
    @content = new View(
	    selector:    
	      '#content'
	    url: =>
	      @current.get()
	    autorefresh: [ @current.slot('changed') ])
	
  init: ->
    @current.set "hello1.html"

$(document).ready ->
  this.App = new Hello
  this.App.init()
