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
    
