(function() {
  var Follower, Gallery, Model, See;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
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
        url: '/model/albums'
      };
      params = $.extend({}, this.defaults, params);
      return $.parseJSON($.ajax(params).responseText);
    };
    Model.prototype.images = function(alb) {
      var params;
      params = {
        url: '/model/images',
        data: {
          albid: alb.toString()
        }
      };
      params = $.extend({}, this.defaults, params);
      return $.parseJSON($.ajax(params).responseText);
    };
    return Model;
  })();
  Follower = (function() {
    function Follower() {
      this.follow = __bind(this.follow, this);;      Follower.__super__.constructor.apply(this, arguments);
    }
    __extends(Follower, Brick);
    Follower.prototype.follow = function(cell, oldvalue, newvalue) {
      return this.move($("img[imgid='" + newvalue + "']").position());
    };
    Follower.prototype.move = function(pos) {
      var css;
      css = {
        "left": pos.left + "px",
        "top": pos.top + "px"
      };
      $('#thumb-hider').css(css);
      return $('#button-box').css(css);
    };
    Follower.prototype.show = function() {
      $('#thumb-hider').show();
      return $('#button-box').show();
    };
    Follower.prototype.hide = function() {
      $('#thumb-hider').hide();
      return $('#button-box').hide();
    };
    return Follower;
  })();
  See = (function() {
    __extends(See, Brick);
    function See(model) {
      this.model = model;
      this.toggleDelete = __bind(this.toggleDelete, this);;
      this.rotateRight = __bind(this.rotateRight, this);;
      this.rotateLeft = __bind(this.rotateLeft, this);;
      this.thumbServerCall = __bind(this.thumbServerCall, this);;
      this.withThumbWait = __bind(this.withThumbWait, this);;
      this.render = __bind(this.render, this);;
      this.wInit = __bind(this.wInit, this);;
      this.currentAlbum = new Cell("Cars");
      this.currentImg = new Cell;
      this.index = new View({
        handler: 'mustache',
        renderData: __bind(function() {
          return {
            albums: this.model.albums(),
            images: this.model.images(this.currentAlbum)
          };
        }, this),
        partials: ['albumSelector', 'thumbs']
      });
      this.follower = new Follower;
    }
    See.prototype.wInit = function() {
      $.wConnect(this.currentAlbum, this.index.thumbs.refresh);
      $.wConnect(this.currentImg, this.follower.follow);
      return $.wConnect(this.currentImg, __bind(function(cell, oldvalue, newvalue) {
        return $('#big-image').attr('src', "/image/" + this.currentAlbum + "/" + newvalue);
      }, this));
    };
    See.prototype.render = function() {
      return this.index.render();
    };
    See.prototype.withThumbWait = function(imgid, contin) {
      var imgTag, oldSrc, unfreeze;
      this.follower.hide();
      imgTag = $(".thumbs > li > img[imgid='" + imgid + "']");
      oldSrc = imgTag.attr('src');
      imgTag.attr('src', '/css/images/wait.gif');
      unfreeze = function() {
        var rnd;
        rnd = "?__x__=" + new Date().getTime();
        imgTag.attr('src', oldSrc + rnd);
        return $("#big-image").attr('src', $("#big-image").attr('src') + rnd);
      };
      return contin(unfreeze);
    };
    See.prototype.thumbServerCall = function(service, success) {
      var albid, imgid;
      albid = this.currentAlbum.get();
      imgid = this.currentImg.get();
      return this.withThumbWait(imgid, function(unwait) {
        return $.ajax({
          url: "/see/" + service,
          type: 'POST',
          data: {
            albid: albid,
            imgid: imgid
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
    See.prototype.rotateLeft = function() {
      return this.thumbServerCall('rotate_left');
    };
    See.prototype.rotateRight = function() {
      return this.thumbServerCall('rotate_right');
    };
    See.prototype.toggleDelete = function() {
      return this.thumbServerCall('toggle_delete', function(albid, imgid) {
        var li;
        li = $(".thumbs > li > img[imgid='" + imgid + "']").parent();
        if (li.parent().attr('id') === "kept-thumbs") {
          return li.appendTo($('#deleted-thumbs'));
        } else {
          return li.appendTo($('#kept-thumbs'));
        }
      });
    };
    return See;
  })();
  Gallery = (function() {
    __extends(Gallery, Brick);
    function Gallery() {
      this.model = new Model;
      this.see = new See(this.model);
      this.main = new View({
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
    return $.wRun(new Gallery);
  });
}).call(this);