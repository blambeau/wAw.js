(function() {
  var Hello;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Hello = (function() {
    __extends(Hello, Brick);
    function Hello() {
      this.current = new Cell;
      this.content = new View({
        selector: '#content',
        url: __bind(function() {
          return this.current.get();
        }, this),
        autorefresh: [this.current.changed]
      });
    }
    Hello.prototype.init = function() {
      return this.current.set('hello1.html');
    };
    return Hello;
  })();
  $(document).ready(function() {
    return Waw.run(new Hello);
  });
}).call(this);
