class GalleryTest extends WawJS.Brick

  recur: (coll, i, fn)=>
    thiz = this
    if i < coll.length
      fn(coll[i], i)
      next = ->
        thiz.recur(coll, i+1, fn)
      setTimeout next, 200

  infinite: (coll, i, fn)=>
    thiz = this
    i = 0 if i >= coll.length
    fn(coll[i], i)
    next = ->
      thiz.infinite(coll, i+1, fn)
    setTimeout next, 200
  
  wInit: =>
    gal = $.wApp.running[0]
    gal.see.setMode('edit')
    gal.see.follower.show()
    images = gal.see.images()
    this.infinite images, 0, (img, i)->
      gal.see.currentImg.set img.imgid
    
$.wApp.ready ()->
  $.wRun(new GalleryTest)
  