class MustacheView extends View
  
  defaults:
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
    @currentImg = new Cell("Coucou")

    # Rendering of the /see page
    @seePage = new MustacheView
      id: 'see'
      data: (v)=>
        { thumbs: @thumbsPage, info: @infoPage }

    # Rendering of the thumbnails at left of /see
    @thumbsPage = new MustacheView
      id: 'thumbs'

    # Rendering of the info at right of /see
    @infoPage = new MustacheView
      id: 'info'
      data: (v)=> 
        {image: @currentImg}
      autorefresh: @currentImg

    # This is the main page, as a View. It will be explicitely
    # refreshed at startup (see wInit)
    @mainPage = new View
      id: "main"
      selector: "#main"
      render: (v)=> 
        @seePage.render()

  # This function is called when the application is started.
  wInit: ->
    @mainPage.refresh()

# When the document is ready, we build an app instance and start 
# running it
$(document).ready ->
  $.gallery = new Gallery
  $.gallery.wRun()
