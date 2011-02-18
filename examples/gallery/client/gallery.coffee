class MustacheView extends View
  
  defaults:
    render: (v)->
      Mustache.to_html(v.template(), v.renderData())
  
  constructor: (opts)->
    super $.extend({}, this.defaults, opts)

class ThumbFollower extends Brick
  
  follow: (cell, oldvalue, newvalue)=>
    this.move $("img[thumb-id='#{newvalue}']").position()

  move: (pos)->
    css = {"left": (pos.left) + "px", "top": (pos.top) + "px"}
    $('#thumb-hider').css(css)
    $('#button-box').css(css)

  show: ->
    $('#thumb-hider').show()
    $('#button-box').show()

  hide: ->
    $('#thumb-hider').hide()
    $('#button-box').hide()

class Model
  
  defaults:
    async: false,
    dataType: 'json',
  
  albums: ->
    params = { url: '/albums.json' }
    params = $.extend({}, this.defaults, params)
    $.parseJSON $.ajax(params).responseText

  images: (alb)->
    params = { url: '/images.json', data: {album: alb.toString()} }
    params = $.extend({}, this.defaults, params)
    $.parseJSON $.ajax(params).responseText

class Gallery extends Brick
  
  # Builds the Gallery brick
  constructor: ->

    # This encapsulates the data model
    @model = new Model
  
    # This cell will keep the name of the current album displayed. 
    @currentAlbum = new Cell("Cars")

    # This cell will keep the name of the current image displayed. 
    @currentImg = new Cell

    # Rendering of the /see page
    @see = new MustacheView
      renderData: =>
        { albums: @albums, thumbs: @thumbs }

    # We listen to currentImg to update the big image at right
    @currentImg.listen (cell, oldvalue, newvalue) =>
      $('#big-image').attr('src', "/image/#{@currentAlbum}/#{newvalue}")

    # We also listen to update a ThumbFollower instance
    @follower = new ThumbFollower
    @currentImg.listen @follower.follow

    # Rendering of the album selector
    @albums = new MustacheView
      renderData: =>
        { albums: @model.albums() }

    # Rendering of the thumbnails at left of /see
    @thumbs = new MustacheView
      renderData: =>
        { images: @model.images(@currentAlbum) }
      autorefresh: 
        @currentAlbum

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