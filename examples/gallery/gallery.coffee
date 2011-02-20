$.wApp ?= {
  onReady: []
  start: ->
    for fn in $.wApp.onReady
      fn()
  ready: (fn)-> 
    $.wApp.onReady.push fn
}
class Gallery extends WawJS.Brick
  
  # Builds the Gallery brick
  constructor: ->

    # This encapsulates the data model
    @model = new Model

    # Creates a see component
    @see = new See(@model)
  
    # This is the main page, as a View. It will be explicitely
    # refreshed at startup (see wInit)
    @main = new WawJS.View
      render: (v)=> 
        @see.render()

  # This function is called when the application is started.
  wInit: ->
    @main.refresh()
    @see.setMode('edit')

# When the document is ready, we build an app instance and start 
# running it
$.wApp.ready ->
  $.wRun(new Gallery)

class GalleryTest 
  
  runAll: ->
    console.log $.wApp
    # gal = $.wApp.running
    # console.log gal.wQid()
    # for i in gal.see.images()
    #   console.log i.imgid
    
$.wApp.ready ()->
  (new GalleryTest).runAll()
  
class Model extends WawJS.Brick

  constructor: ->
    super
  
  defaults:
    async: false,
    dataType: 'json',
  
  albums: ->
    params = { url: '/model/albums' }
    params = $.extend({}, this.defaults, params)
    $.parseJSON $.ajax(params).responseText

  images: (alb)->
    params = { url: '/model/images', data: {albid: alb.toString()} }
    params = $.extend({}, this.defaults, params)
    $.parseJSON $.ajax(params).responseText


class Diaporama extends WawJS.Brick

  constructor: ->
    @started = false
  
  reinit: =>
    @images = this.wParent().images()
    @current = 0
  
  onImageChange: =>
    this.wParent().resetBigImage(1000, 1000)
  
  start: (see)=>
    thiz = this

    # Initial values
    thiz.reinit()
    $.wConnect see.currentAlbum, thiz.reinit
    $.wConnect see.currentImg, thiz.onImageChange
        
    # Register the timeout function now
    func = ->
      if thiz.started
        thiz.current = (thiz.current + 1) % thiz.images.length
        see.currentImg.set thiz.images[thiz.current].imgid
        setTimeout(func, 3000)
    setTimeout func, 3000

    # Mark as started
    @started = true
    
  stop: (see)=>
    @started = false
    $.wDisconnect see.currentAlbum, this.reinit
    $.wDisconnect see.currentImg, this.onImageChange

class Follower extends WawJS.Brick
  
  constructor: ->
    @started = false
  
  onImageChange: (cell, oldvalue, newvalue)=>
    this.move $("img[imgid='#{newvalue}']").position()
    this.wParent().resetBigImage(10, 10)

  set: (imgid)=>
    this.wParent().currentImg.set(imgid)
    this.show()

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
  
  start: (see)=>
    thiz = this
    $.wConnect see.currentImg, thiz.onImageChange
    $('.thumb').mouseover ->
      img = $(this).attr('imgid');
      thiz.set(img)
    $('#button-box').mouseleave ->
      thiz.hide()
    @started = true
    
  stop: (see)=>
    thiz = this
    $.wDisconnect see.currentImg, thiz.onImageChange
    $('.thumb').unbind 'mouseover'
    $('#button-box').unbind 'mouseleave'
    thiz.hide()
    @started = false
    

class See extends WawJS.Brick
  
  # Builds the Gallery brick
  constructor: (@model)->

    # This cell will keep the name of the current album displayed
    @currentAlbum = new WawJS.Cell("Cars")

    # This cell will keep the name of the current image displayed
    @currentImg = new WawJS.Cell

    # Rendering of the /see page
    @index = new WawJS.View
      handler:  'mustache'
      renderData: => { albums: @model.albums(), images: @model.images(@currentAlbum) }
      partials: [ 'albumSelector', 'thumbs' ]

    # We also listen to update a Follower instance
    @follower  = new Follower
    @diapo = new Diaporama

    # This cell will keep the current mode 
    @mode = new WawJS.Cell
    
  wInit: =>
    thiz = this
    $.wConnect @currentAlbum, @index.thumbs.refresh
    $.wConnect @mode, (c,oldval,newval)=>
      oldval.stop(this) if oldval?
      newval.start(this) if newval?

  render: => 
    @index.render()
    
  images: =>
    @model.images(@currentAlbum)
    
  setMode: (mode)=>
    switch mode
      when 'edit'
        @mode.set(@follower)
      when 'diapo'
        @mode.set(@diapo)
  
  resetBigImage: (fOut, fIn)=>
    thiz = this
    $('#big-image').fadeOut fOut, ->
      $('#big-image').attr('src', "/image/#{thiz.currentAlbum}/#{thiz.currentImg}")
      $('#big-image').fadeIn(fIn)
    
  withThumbWait: (imgid, contd)=>
    # Set wait.gif
    @follower.hide()
    imgTag = $(".thumbs > li > img[imgid='#{imgid}']")
    oldSrc = imgTag.attr('src')
    imgTag.attr('src', '/css/images/wait.gif')

    unfreeze = ->
      rnd = "?__x__=" + new Date().getTime()
      imgTag.attr('src', oldSrc + rnd)
      $("#big-image").attr('src', $("#big-image").attr('src') + rnd)

    contd(unfreeze)

  thumbServerCall: (service, success)=>
    albid = @currentAlbum.get()
    imgid = @currentImg.get()
    this.withThumbWait imgid, (unwait)->
      $.ajax
        url: "/see/#{service}"
        type: 'POST'
        data: { albid: albid, imgid: imgid }
        success: ->
          success(albid, imgid) if success?
          unwait()
        error: unwait

  rotateLeft: =>
    this.thumbServerCall 'rotate_left'
    
  rotateRight: =>
    this.thumbServerCall 'rotate_right'

  toggleDelete: =>
    this.thumbServerCall 'toggle_delete', (albid, imgid)->
      li = $(".thumbs > li > img[imgid='#{imgid}']").parent()
      if li.parent().attr('id') == "kept-thumbs"
        li.appendTo $('#deleted-thumbs')
      else
        li.appendTo $('#kept-thumbs')
if $.wApp.onReady? 
  $.wApp.start()
