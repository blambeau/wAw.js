class Gallery extends Brick
  
  # Builds the Gallery brick
  constructor: ->
    
    # This is the main page, as a View. It will be explicitely
    # refreshed at startup (see wInit)
    @mainPage = new View
      selector: '#main-page'
      url:      'main-page'

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

  # This function is called when the application is started.
  wInit: ->
    @mainPage.refresh()

# When the document is ready, we build an app instance and start 
# running it
$(document).ready ->
  $.gallery = new Gallery
  $.gallery.wRun()
