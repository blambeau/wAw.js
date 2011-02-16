this.Hello = class Hello extends App

  # Cell for the current view
  current: new Cell

  # View handler for #content 
  content: new View
      selector: 
        '#content'
      url:      
        -> Waw.get('current')
      autorefresh: [
        'current/changed'
      ]

  init: ->
    this.current.set('hello1.html')
  
$(document).ready ->
  Waw.run(new Hello)