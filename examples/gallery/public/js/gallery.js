(function() {
  var Gallery, MustacheView;
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
      url: function(v) {
        return "/" + (v.id());
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
          dataType: 'json'
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
  Gallery = (function() {
    __extends(Gallery, Brick);
    function Gallery() {
      this.currentImg = new Cell;
      this.seePage = new MustacheView({
        id: 'see',
        data: __bind(function(v) {
          return {
            thumbs: this.thumbsPage,
            info: this.infoPage
          };
        }, this)
      });
      this.thumbsPage = new MustacheView({
        id: 'thumbs'
      });
      this.infoPage = new MustacheView({
        id: 'info',
        data: __bind(function(v) {
          return {
            image: this.currentImg
          };
        }, this),
        autorefresh: this.currentImg
      });
      this.mainPage = new View({
        id: "main",
        selector: "#main",
        render: __bind(function(v) {
          return this.seePage.render();
        }, this)
      });
    }
    Gallery.prototype.wInit = function() {
      return this.mainPage.refresh();
    };
    return Gallery;
  })();
  $(document).ready(function() {
    $.gallery = new Gallery;
    return $.gallery.wRun();
  });
}).call(this);
