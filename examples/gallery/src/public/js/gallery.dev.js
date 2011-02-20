var $.wApp;
if (typeof($.wApp) == "undefined" || $.wApp == null) {
  $.wApp = function(){};
}
(function(exports) {
  var builder, require;
  builder = [];
  require = function(name) {
    var _ref;
    (_ref = exports[name]) != null ? _ref : exports[name] = builder[name](exports);
    return exports;
  };
  builder['./$.wApp'] = function(exports){
    var Diaporama, Follower, Gallery, Model, See;
    var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
      for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
      function ctor() { this.constructor = child; }
      ctor.prototype = parent.prototype;
      child.prototype = new ctor;
      child.__super__ = parent.prototype;
      return child;
    }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
    Gallery = (function() {
      __extends(Gallery, WawJS.Brick);
      function Gallery() {
        this.model = new Model;
        this.see = new See(this.model);
        this.main = new WawJS.View({
          render: __bind(function(v) {
            return this.see.render();
          }, this)
        });
      }
      Gallery.prototype.wInit = function() {
        this.main.refresh();
        return this.see.setMode('edit');
      };
      return Gallery;
    })();
    $.wApp.ready(function() {
      return $.wRun(new Gallery);
    });
    Model = (function() {
      __extends(Model, WawJS.Brick);
      function Model() {
        Model.__super__.constructor.apply(this, arguments);
      }
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
    Diaporama = (function() {
      __extends(Diaporama, WawJS.Brick);
      function Diaporama() {
        this.stop = __bind(this.stop, this);;
        this.start = __bind(this.start, this);;
        this.onImageChange = __bind(this.onImageChange, this);;
        this.reinit = __bind(this.reinit, this);;    this.started = false;
      }
      Diaporama.prototype.reinit = function() {
        this.images = this.wParent().images();
        return this.current = 0;
      };
      Diaporama.prototype.onImageChange = function() {
        return this.wParent().resetBigImage(1000, 1000);
      };
      Diaporama.prototype.start = function(see) {
        var func, thiz;
        thiz = this;
        thiz.reinit();
        $.wConnect(see.currentAlbum, thiz.reinit);
        $.wConnect(see.currentImg, thiz.onImageChange);
        func = function() {
          if (thiz.started) {
            thiz.current = (thiz.current + 1) % thiz.images.length;
            see.currentImg.set(thiz.images[thiz.current].imgid);
            return setTimeout(func, 3000);
          }
        };
        setTimeout(func, 3000);
        return this.started = true;
      };
      Diaporama.prototype.stop = function(see) {
        this.started = false;
        $.wDisconnect(see.currentAlbum, this.reinit);
        return $.wDisconnect(see.currentImg, this.onImageChange);
      };
      return Diaporama;
    })();
    Follower = (function() {
      __extends(Follower, WawJS.Brick);
      function Follower() {
        this.stop = __bind(this.stop, this);;
        this.start = __bind(this.start, this);;
        this.set = __bind(this.set, this);;
        this.onImageChange = __bind(this.onImageChange, this);;    this.started = false;
      }
      Follower.prototype.onImageChange = function(cell, oldvalue, newvalue) {
        this.move($("img[imgid='" + newvalue + "']").position());
        return this.wParent().resetBigImage(10, 10);
      };
      Follower.prototype.set = function(imgid) {
        this.wParent().currentImg.set(imgid);
        return this.show();
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
      Follower.prototype.start = function(see) {
        var thiz;
        thiz = this;
        $.wConnect(see.currentImg, thiz.onImageChange);
        $('.thumb').mouseover(function() {
          var img;
          img = $(this).attr('imgid');
          return thiz.set(img);
        });
        $('#button-box').mouseleave(function() {
          return thiz.hide();
        });
        return this.started = true;
      };
      Follower.prototype.stop = function(see) {
        var thiz;
        thiz = this;
        $.wDisconnect(see.currentImg, thiz.onImageChange);
        $('.thumb').unbind('mouseover');
        $('#button-box').unbind('mouseleave');
        thiz.hide();
        return this.started = false;
      };
      return Follower;
    })();
    See = (function() {
      __extends(See, WawJS.Brick);
      function See(model) {
        this.model = model;
        this.toggleDelete = __bind(this.toggleDelete, this);;
        this.rotateRight = __bind(this.rotateRight, this);;
        this.rotateLeft = __bind(this.rotateLeft, this);;
        this.thumbServerCall = __bind(this.thumbServerCall, this);;
        this.withThumbWait = __bind(this.withThumbWait, this);;
        this.resetBigImage = __bind(this.resetBigImage, this);;
        this.setMode = __bind(this.setMode, this);;
        this.images = __bind(this.images, this);;
        this.render = __bind(this.render, this);;
        this.wInit = __bind(this.wInit, this);;
        this.currentAlbum = new WawJS.Cell("Cars");
        this.currentImg = new WawJS.Cell;
        this.index = new WawJS.View({
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
        this.diapo = new Diaporama;
        this.mode = new WawJS.Cell;
      }
      See.prototype.wInit = function() {
        var thiz;
        thiz = this;
        $.wConnect(this.currentAlbum, this.index.thumbs.refresh);
        return $.wConnect(this.mode, __bind(function(c, oldval, newval) {
          if (oldval != null) {
            oldval.stop(this);
          }
          if (newval != null) {
            return newval.start(this);
          }
        }, this));
      };
      See.prototype.render = function() {
        return this.index.render();
      };
      See.prototype.images = function() {
        return this.model.images(this.currentAlbum);
      };
      See.prototype.setMode = function(mode) {
        switch (mode) {
          case 'edit':
            return this.mode.set(this.follower);
          case 'diapo':
            return this.mode.set(this.diapo);
        }
      };
      See.prototype.resetBigImage = function(fOut, fIn) {
        var thiz;
        thiz = this;
        return $('#big-image').fadeOut(fOut, function() {
          $('#big-image').attr('src', "/image/" + thiz.currentAlbum + "/" + thiz.currentImg);
          return $('#big-image').fadeIn(fIn);
        });
      };
      See.prototype.withThumbWait = function(imgid, contd) {
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
        return contd(unfreeze);
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
  };
  require('./$.wapp');
}).call(this, $.wApp);
