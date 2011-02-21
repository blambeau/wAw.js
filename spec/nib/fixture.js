Nib.define('fixture', function(nib) {
  nib.register('./app', function(exports, require) {
    var App;
    return exports.App = App = (function() {
      function App() {}
      App.prototype.say_hello = function() {
        return "Hello from App";
      };
      return App;
    })();
  });
  nib.register('./dependent', function(exports, require) {
    var App, Dependent;
    App = require('./app').App;
    return exports.Dependent = Dependent = (function() {
      function Dependent() {}
      Dependent.prototype.say_hello = function() {
        return "Hello from Dependent";
      };
      return Dependent;
    })();
  });
  nib.register('./index', function(exports, require) {
    exports.App = require('./app').App;
    return exports.Dependent = require('./dependent').Dependent;
  });
  return nib.require('./index');
});
