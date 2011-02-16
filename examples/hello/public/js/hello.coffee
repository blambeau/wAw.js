class Hello extends Brick

  # Cell for the current view
  current: new Cell

  # View handler for #content 
  content: new View
      selector: 
        '#content'
      url: ->
        this.wget('../current');
      autorefresh: [
        '../current/changed'
      ]

  init: ->
    this.current.set('hello1.html')
  
$(document).ready ->
  Waw.run(new Hello)