class Diaporama extends WawJS.Brick

  constructor: ->
    @started = false
  
  reinit: =>
    @images = this.wParent().images()
    @current = 0
  
  start: (see)=>
    thiz = this

    # Initial values
    thiz.reinit()
    $.wConnect see.currentAlbum, thiz.reinit
        
    # Register the timeout function now
    func = ->
      thiz.current = (thiz.current + 1) % thiz.images.length
      see.currentImg.set thiz.images[thiz.current].imgid
      setTimeout(func, 2000) if thiz.started
    setTimeout func, 2000

    # Mark as started
    @started = true
    
  stop: (see)=>
    @started = false
    $.wDisconnect see.currentAlbum, this.reinit
