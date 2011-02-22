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

  reinit: =>
    thiz = this
    $('.thumb').mouseover ->
      img = $(this).attr('imgid');
      thiz.set(img)
    $('#button-box').mouseleave ->
      thiz.hide()

  show: ->
    $('#thumb-hider').show()
    $('#button-box').show()

  hide: ->
    $('#thumb-hider').hide()
    $('#button-box').hide()
  
  start: (see)=>
    thiz = this
    $.wConnect see.currentImg, thiz.onImageChange
    $.wConnect see.currentAlbum, thiz.reinit
    thiz.reinit()
    @started = true
    
  stop: (see)=>
    thiz = this
    $.wDisconnect see.currentImg, thiz.onImageChange
    $.wDisconnect see.currentAlbum, thiz.reinit
    $('.thumb').unbind 'mouseover'
    $('#button-box').unbind 'mouseleave'
    thiz.hide()
    @started = false
    
