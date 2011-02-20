class Follower extends WawJS.Brick
  
  constructor: ->
    @started = false
  
  follow: (cell, oldvalue, newvalue)=>
    this.move $("img[imgid='#{newvalue}']").position()

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
    $.wConnect see.currentImg, thiz.follow
    $('.thumb').mouseover ->
      img = $(this).attr('imgid');
      thiz.set(img)
    $('#button-box').mouseleave ->
      thiz.hide()
    thiz.show()
    @started = true
    
  stop: (see)=>
    thiz = this
    see.currentImg.unlisten(thiz.follow)
    $('.thumb').unbind 'mouseover'
    $('#button-box').unbind 'mouseleave'
    thiz.hide()
    @started = false
    
