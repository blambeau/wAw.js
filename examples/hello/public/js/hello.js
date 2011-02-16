(function() {
  var Hello;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Hello = (function() {
    function Hello() {
      this.current = new Cell;
      this.content = new View({
        selector: '#content',
        url: __bind(function() {
          return this.current.get();
        }, this),
        autorefresh: [this.current.slot('changed')]
      });
    }
    Hello.prototype.init = function() {
      return this.current.set("hello1.html");
    };
    return Hello;
  })();
  $(document).ready(function() {
    this.App = new Hello;
    return this.App.init();
  });
}).call(this);
