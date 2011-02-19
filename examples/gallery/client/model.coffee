class Model extends Brick
  
  defaults:
    async: false,
    dataType: 'json',
  
  albums: ->
    params = { url: '/albums.json' }
    params = $.extend({}, this.defaults, params)
    $.parseJSON $.ajax(params).responseText

  images: (alb)->
    params = { url: '/images.json', data: {album: alb.toString()} }
    params = $.extend({}, this.defaults, params)
    $.parseJSON $.ajax(params).responseText

