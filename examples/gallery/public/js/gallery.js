(function() {
  var Gallery, Model, MustacheView, ThumbFollower;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  MustacheView = (function() {
    __extends(MustacheView, View);
    MustacheView.prototype.defaults = {
      render: function(v) {
        return Mustache.to_html(v.template(), v.renderData());
      }
    };
    function MustacheView(opts) {
      MustacheView.__super__.constructor.call(this, $.extend({}, this.defaults, opts));
    }
    return MustacheView;
  })();
  ThumbFollower = (function() {
    function ThumbFollower() {
      this.follow = __bind(this.follow, this);;      ThumbFollower.__super__.constructor.apply(this, arguments);
    }
    __extends(ThumbFollower, Brick);
    ThumbFollower.prototype.follow = function(cell, oldvalue, newvalue) {
      return this.move($("img[thumb-id='" + newvalue + "']").position());
    };
    ThumbFollower.prototype.move = function(pos) {
      var css;
      css = {
        "left": pos.left + "px",
        "top": pos.top + "px"
      };
      $('#thumb-hider').css(css);
      return $('#button-box').css(css);
    };
    ThumbFollower.prototype.show = function() {
      $('#thumb-hider').show();
      return $('#button-box').show();
    };
    ThumbFollower.prototype.hide = function() {
      $('#thumb-hider').hide();
      return $('#button-box').hide();
    };
    return ThumbFollower;
  })();
  Model = (function() {
    function Model() {}
    Model.prototype.defaults = {
      async: false,
      dataType: 'json'
    };
    Model.prototype.albums = function() {
      var params;
      params = {
        url: '/albums.json'
      };
      params = $.extend({}, this.defaults, params);
      return $.parseJSON($.ajax(params).responseText);
    };
    Model.prototype.images = function(alb) {
      var params;
      params = {
        url: '/images.json',
        data: {
          album: alb.toString()
        }
      };
      params = $.extend({}, this.defaults, params);
      return $.parseJSON($.ajax(params).responseText);
    };
    return Model;
  })();
  Gallery = (function() {
    __extends(Gallery, Brick);
    function Gallery() {
      this.model = new Model;
      this.currentAlbum = new Cell("Cars");
      this.currentImg = new Cell;
      this.see = new MustacheView({
        renderData: __bind(function() {
          return {
            albums: this.albums,
            thumbs: this.thumbs
          };
        }, this)
      });
      this.currentImg.listen(__bind(function(cell, oldvalue, newvalue) {
        return $('#big-image').attr('src', "/image/" + this.currentAlbum + "/" + newvalue);
      }, this));
      this.follower = new ThumbFollower;
      this.currentImg.listen(this.follower.follow);
      this.albums = new MustacheView({
        renderData: __bind(function() {
          return {
            albums: this.model.albums()
          };
        }, this)
      });
      this.thumbs = new MustacheView({
        renderData: __bind(function() {
          return {
            images: this.model.images(this.currentAlbum)
          };
        }, this),
        autorefresh: this.currentAlbum
      });
      this.main = new MustacheView({
        render: __bind(function(v) {
          return this.see.render();
        }, this)
      });
    }
    Gallery.prototype.wInit = function() {
      return this.main.refresh();
    };
    return Gallery;
  })();
  $(document).ready(function() {
    $.gallery = new Gallery;
    return $.gallery.wRun();
  });
}).call(this);
