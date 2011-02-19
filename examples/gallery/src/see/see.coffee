class Follower extends Waw.Brick
  
  follow: (cell, oldvalue, newvalue)=>
    this.move $("img[imgid='#{newvalue}']").position()

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

class See extends Waw.Brick
  
  # Builds the Gallery brick
  constructor: (@model)->

    # This cell will keep the name of the current album displayed. 
    @currentAlbum = new Waw.Cell("Cars")

    # This cell will keep the name of the current image displayed. 
    @currentImg = new Waw.Cell

    # Rendering of the /see page
    @index = new Waw.View
      handler:  'mustache'
      renderData: => { albums: @model.albums(), images: @model.images(@currentAlbum) }
      partials: [ 'albumSelector', 'thumbs' ]

    # We also listen to update a Follower instance
    @follower = new Follower

  wInit: =>
	  $.wConnect @currentAlbum, @index.thumbs.refresh
	  $.wConnect @currentImg, @follower.follow
	  $.wConnect @currentImg, (cell, oldvalue, newvalue) =>
      $('#big-image').attr('src', "/image/#{@currentAlbum}/#{newvalue}")

  render: => 
    @index.render()

  withThumbWait: (imgid, contin)=>
    # Set wait.gif
    @follower.hide()
    imgTag = $(".thumbs > li > img[imgid='#{imgid}']")
    oldSrc = imgTag.attr('src')
    imgTag.attr('src', '/css/images/wait.gif')

    unfreeze = ->
      rnd = "?__x__=" + new Date().getTime()
      imgTag.attr('src', oldSrc + rnd)
      $("#big-image").attr('src', $("#big-image").attr('src') + rnd)

    contin(unfreeze)

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
