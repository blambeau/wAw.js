class MustacheView extends View
  
  defaults:
	  id: (v)-> 
      "#{v.wName()}"
	  url: (v)-> 
      "/#{v.id()}"
    selector: (v)->
      "#" + v.id()
    template: (v)->
      v._template ?= $.ajax(url: "#{v.url()}.whtml", async: false).responseText
    data: (v)->
      $.parseJSON $.ajax(url: "#{v.url()}.json", async: false, dataType: 'json').responseText
    render: (v)->
      Mustache.to_html(v.template(), v.data())
  
  constructor: (opts)->
    super $.extend({}, this.defaults, opts)

class Gallery extends Brick
  
  # Builds the Gallery brick
  constructor: ->
  
    # This cell will keep the name of the current image displayed. 
    # Views that depend on the current image automatically refresh 
    # thanks to the listen support.
    @currentImg = new Cell

    # Rendering of the /see page
    @see = new MustacheView
      data: (v)=>
        { thumbs: @thumbs, info: @info }

    # Rendering of the thumbnails at left of /see
    @thumbs = new MustacheView

    # Rendering of the info at right of /see
    @info = new MustacheView
      data: (v)=> 
        { image: @currentImg }
      autorefresh: @currentImg

    # This is the main page, as a View. It will be explicitely
    # refreshed at startup (see wInit)
    @main = new MustacheView
      render: (v)=> 
        @see.render()

  # This function is called when the application is started.
  wInit: ->
    @main.refresh()

# When the document is ready, we build an app instance and start 
# running it
$(document).ready ->
  $.gallery = new Gallery
  $.gallery.wRun()
