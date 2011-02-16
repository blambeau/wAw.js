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
    function Hello() {
      Hello.__super__.constructor.apply(this, arguments);
    }
    __extends(Hello, Brick);
    Hello.prototype.current = new Cell;
    Hello.prototype.content = new View({
      selector: '#content',
      url: function() {
        return this.wget('../current');
      },
      autorefresh: ['../current/changed']
    });
    Hello.prototype.init = function() {
      return this.current.set('hello1.html');
    };
    return Hello;
  })();
  $(document).ready(function() {
    return Waw.run(new Hello);
  });
}).call(this);
