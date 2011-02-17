(function() {
  var Hello;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  Hello = (function() {
    __extends(Hello, Brick);
    function Hello() {
      this.current = new Cell;
      this.content = new View({
        selector: '#content',
        url: this.current,
        autorefresh: this.current.changed
      });
    }
    Hello.prototype.wInit = function() {
      return this.current.set('hello1.html');
    };
    return Hello;
  })();
  $(document).ready(function() {
    this.HelloApp = new Hello;
    return this.HelloApp.wRun();
  });
}).call(this);
