(function() {
  var Gallery, MustacheView, ThumbFollower;
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
      id: function(v) {
        return "" + (v.wName());
      },
      url: function(v) {
        return "/" + (v.id());
      },
      ajaxData: function(v) {
        return {};
      },
      selector: function(v) {
        return "#" + v.id();
      },
      template: function(v) {
        var _ref;
        return (_ref = v._template) != null ? _ref : v._template = $.ajax({
          url: "" + (v.url()) + ".whtml",
          async: false
        }).responseText;
      },
      data: function(v) {
        return $.parseJSON($.ajax({
          url: "" + (v.url()) + ".json",
          async: false,
          dataType: 'json',
          data: v.ajaxData()
        }).responseText);
      },
      render: function(v) {
        return Mustache.to_html(v.template(), v.data());
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
  Gallery = (function() {
    __extends(Gallery, Brick);
    function Gallery() {
      this.currentAlbum = new Cell("Cars");
      this.currentImg = new Cell;
      this.see = new MustacheView({
        data: __bind(function(v) {
          return {
            albums: this.albums,
            thumbs: this.thumbs,
            currentImg: this.currentImg
          };
        }, this)
      });
      this.currentImg.listen(__bind(function(cell, oldvalue, newvalue) {
        return $('#big-image').attr('src', "/image/" + this.currentAlbum + "/" + newvalue);
      }, this));
      this.follower = new ThumbFollower;
      this.currentImg.listen(this.follower.follow);
      this.albums = new MustacheView;
      this.thumbs = new MustacheView({
        ajaxData: __bind(function() {
          return {
            album: this.currentAlbum.get()
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
