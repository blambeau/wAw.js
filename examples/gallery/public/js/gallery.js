(function() {
  var Gallery, Model, ThumbFollower;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  ThumbFollower = (function() {
    function ThumbFollower() {
      this.follow = __bind(this.follow, this);;      ThumbFollower.__super__.constructor.apply(this, arguments);
    }
    __extends(ThumbFollower, Brick);
    ThumbFollower.prototype.follow = function(cell, oldvalue, newvalue) {
      return this.move($("img[imgid='" + newvalue + "']").position());
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
    function Model() {
      Model.__super__.constructor.apply(this, arguments);
    }
    __extends(Model, Brick);
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
      this.toggleDelete = __bind(this.toggleDelete, this);;
      this.rotateRight = __bind(this.rotateRight, this);;
      this.rotateLeft = __bind(this.rotateLeft, this);;
      this.thumbServerCall = __bind(this.thumbServerCall, this);;
      this.withThumbWait = __bind(this.withThumbWait, this);;      this.model = new Model;
      this.currentAlbum = new Cell("Cars");
      this.currentImg = new Cell;
      this.see = new View({
        handler: 'mustache',
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
      this.albums = new View({
        handler: 'mustache',
        renderData: __bind(function() {
          return {
            albums: this.model.albums()
          };
        }, this)
      });
      this.thumbs = new View({
        handler: 'mustache',
        renderData: __bind(function() {
          return {
            images: this.model.images(this.currentAlbum)
          };
        }, this),
        autorefresh: this.currentAlbum
      });
      this.main = new View({
        render: __bind(function(v) {
          return this.see.render();
        }, this)
      });
    }
    Gallery.prototype.wInit = function() {
      return this.main.refresh();
    };
    Gallery.prototype.withThumbWait = function(imgid, contin) {
      var imgTag, oldSrc, unfreeze;
      this.follower.hide();
      imgTag = $(".thumbs > li > img[imgid='" + imgid + "']");
      oldSrc = imgTag.attr('src');
      imgTag.attr('src', '/css/images/wait.gif');
      unfreeze = function() {
        imgTag.attr('src', oldSrc);
        return $("#big-image}").attr('src', $("#big-image}").attr('src'));
      };
      return contin(unfreeze);
    };
    Gallery.prototype.thumbServerCall = function(service, success) {
      var albid, imgid;
      albid = this.currentAlbum.get();
      imgid = this.currentImg.get();
      return this.withThumbWait(imgid, function(unwait) {
        return $.ajax({
          url: service,
          type: 'POST',
          data: {
            album: albid,
            image: imgid
          },
          success: function() {
            if (success != null) {
              success(albid, imgid);
            }
            return unwait();
          },
          error: unwait
        });
      });
    };
    Gallery.prototype.rotateLeft = function() {
      return this.thumbServerCall('/rotate-left');
    };
    Gallery.prototype.rotateRight = function() {
      return this.thumbServerCall('/rotate-right');
    };
    Gallery.prototype.toggleDelete = function() {
      return this.thumbServerCall('/toggle-delete', function(albid, imgid) {
        var li;
        li = $(".thumbs > li > img[imgid='" + imgid + "']").parent();
        if (li.parent().attr('id') === "kept-thumbs") {
          return li.appendTo($('#deleted-thumbs'));
        } else {
          return li.appendTo($('#kept-thumbs'));
        }
      });
    };
    return Gallery;
  })();
  $(document).ready(function() {
    $.gallery = new Gallery;
    return $.gallery.wRun();
  });
}).call(this);
