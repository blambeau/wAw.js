(function() {
  var Gallery;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Gallery = (function() {
    __extends(Gallery, Brick);
    function Gallery() {
      this.currentImg = new Cell;
      this.currentImg.listen(function(cell, oldval, newval) {
        return $('#image-display img').attr('src', "/images/" + newval);
      });
      this.mainPage = new View({
        selector: '#main-page',
        url: 'main-page'
      });
      this.imageInfo = new View({
        selector: '#image-info',
        url: function(v) {
          return "image-info/" + (v.wGet('/currentImg'));
        },
        autorefresh: this.currentImg
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
