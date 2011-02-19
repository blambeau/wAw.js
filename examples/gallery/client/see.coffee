class See extends Brick
  
  # Builds the Gallery brick
  constructor: (@model)->

    # This cell will keep the name of the current album displayed. 
    @currentAlbum = new Cell("Cars")

    # This cell will keep the name of the current image displayed. 
    @currentImg = new Cell

    # Rendering of the /see page
    @index = new View
      handler:  'mustache'
      partials: [ 'albumSelector', 'thumbs' ]

    # We also listen to update a Follower instance
    @follower = new Follower

  wInit: =>
	  @currentAlbum.listen @index.thumbs.refresh 
    @currentImg.listen   @follower.follow
    @currentImg.listen (cell, oldvalue, newvalue) =>
      $('#big-image').attr('src', "/image/#{@currentAlbum}/#{newvalue}")

  albums: =>
	  @model.albums()

  images: =>
	  @model.images(@currentAlbum)

  render: => 
    @index.render()

  withThumbWait: (imgid, contin)=>
    # Set wait.gif
    @follower.hide()
    imgTag = $(".thumbs > li > img[imgid='#{imgid}']")
    oldSrc = imgTag.attr('src')
    imgTag.attr('src', '/css/images/wait.gif')

    unfreeze = ->
      imgTag.attr('src', oldSrc)
      $("#big-image}").attr('src', $("#big-image}").attr('src'))

    contin(unfreeze)

  thumbServerCall: (service, success)=>
    albid = @currentAlbum.get()
    imgid = @currentImg.get()
    this.withThumbWait imgid, (unwait)->
      $.ajax
        url: service
        type: 'POST'
        data: { album: albid, image: imgid }
        success: ->
          success(albid, imgid) if success?
          unwait()
        error: unwait

  rotateLeft: =>
    this.thumbServerCall '/rotate-left'
    
  rotateRight: =>
    this.thumbServerCall '/rotate-right'

  toggleDelete: =>
    this.thumbServerCall '/toggle-delete', (albid, imgid)->
      li = $(".thumbs > li > img[imgid='#{imgid}']").parent()
      if li.parent().attr('id') == "kept-thumbs"
        li.appendTo $('#deleted-thumbs')
      else
        li.appendTo $('#kept-thumbs')
