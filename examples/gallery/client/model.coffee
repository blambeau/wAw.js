class Model extends Brick
  
  defaults:
    async: false,
    dataType: 'json',
  
  albums: ->
    params = { url: '/model/albums' }
    params = $.extend({}, this.defaults, params)
    $.parseJSON $.ajax(params).responseText

  images: (alb)->
    params = { url: '/model/images', data: {albid: alb.toString()} }
    params = $.extend({}, this.defaults, params)
    $.parseJSON $.ajax(params).responseText

