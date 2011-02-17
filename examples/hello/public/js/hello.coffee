class Hello extends Brick
  
  constructor: ->
  
    # Cell for the current view
    @current = new Cell

    # View handler for #content 
    @content = new View
      selector: 
        '#content'
      url: 
        this.current
      autorefresh:
        this.current.changed

  wInit: ->
    this.current.set('hello1.html')
  
$(document).ready ->
  this.HelloApp = new Hello
  this.HelloApp.wRun()