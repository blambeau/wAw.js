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
    $.wConnect @currentImg, (c, oldval, newval)->
      $('#big-image').fadeOut 100, ->
        $('#big-image').attr('src', "/image/#{thiz.currentAlbum}/#{newval}")
        $('#big-image').fadeIn(100)
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
