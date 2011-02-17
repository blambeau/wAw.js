# wAw.js - web framework working Another way

wAw.js is a small truly MVC web framework. Main features are:

- Server side is whatever you want, wAw.js does not make particular assumptions
  about it. Typical choice is ruby/sinatra.
- Client side code is friendly javascript code (or better, coffeescript code) 
  implementing a real but tiny MVC architecture. By _real_ we mean that your 
  views listen to state variables and refresh automatically, as expected with
  MVC
- wAw.js uses a component approach, through Bricks. A brick is a self contained
  component that embeds its state (via Cell), its actions (via Action) and its
  views (via View). Bricks built this way are easier to reuse.

## Example (see the examples folder)

    # An image gallery
    class Gallery extends Brick
      constructor: ->
    
        # This cell will keep the name of the current image displayed. 
        # Views that depend on the current image automatically refresh 
        # thanks to the listen support.
        @currentImg = new Cell

        # The big image at right can simply be reloaded via an explicit 
        # listen to the cell.
        @currentImg.listen (cell, oldval, newval)->
          $('#image-display img').attr('src', "/images/#{newval}")
    
        # The information page will better be a view, autorefreshed when
        # when the cell changes. Dynamic URLs can simply be installed via 
        # a function.
        @imageInfo = new View
          selector:    '#image-info'
          autorefresh: this.currentImg
          url: (v)-> 
    	      "image-info/" + v.wGet('/currentImg')

    # When the document is ready, we build an app instance and start 
    # running it
    $(document).ready ->
      $.gallery = new Gallery
      $.gallery.wRun()
  
  

