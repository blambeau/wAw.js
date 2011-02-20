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
