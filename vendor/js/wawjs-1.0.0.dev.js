/**
 * wAw.js micro web framework v1.0.0
 * http://github.com/blambeau/waw.js
 *
 * Copyright 2011, Bernard Lambeau
 * Released under the MIT License
 */
var WawJS;
(_ref = WawJS) != null ? _ref : WawJS = {
  onReady: [],
  start: function() {
    var fn, _i, _len, _ref, _results;
    _ref = WawJS.onReady;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      fn = _ref[_i];
      _results.push(fn());
    }
    return _results;
  },
  ready: function(fn) {
    return WawJS.onReady.push(fn);
  }
};
(function(exports) {
  var builder, require;
  builder = [];
  require = function(name) {
    var _ref;
    (_ref = exports[name]) != null ? _ref : exports[name] = builder[name](exports);
    return exports;
  };
  builder['./brick'] = function(exports){
    var Brick, Signal;
    var __slice = Array.prototype.slice;
    Signal = require('./signal').Signal;
    exports.Brick = Brick = (function() {
      function Brick(opts) {
        var defs;
        if (opts == null) {
          opts = {};
        }
        try {
          defs = this.__proto__.constructor.prototype.defaults;
          this.options = $.extend({}, defs, opts);
        } catch (err) {
          this.options = opts;
        }
      }
      Brick.prototype._wInit = function(parent, name) {
        var k, pwQid, v;
        if (parent != null) {
          this._wRoot = parent.wRoot();
          this._wParent = parent;
        } else {
          this._wRoot = this;
          this._wParent = null;
        }
        this._wName = name;
        this._wQid = this._wParent === null ? '/' : (pwQid = this._wParent.wQid(), pwQid === '/' ? pwQid + this._wName : pwQid + '/' + this._wName);
        for (k in this) {
          v = this[k];
          if (k[0] === '_') {
            continue;
          } else if ((v != null) && (v['_wInit'] != null)) {
            v._wInit(this, k);
          } else if ((v != null) && (v['wInit'] != null)) {
            v.wInit(this, k);
          }
        }
        if (this['wInit'] != null) {
          return this.wInit(parent, k);
        }
      };
      Brick.prototype.wInit = function(parent, name) {
        var f, k, v, _ref, _results;
        _ref = this.options;
        _results = [];
        for (k in _ref) {
          v = _ref[k];
          f = this._build_function(v);
          _results.push(this[k] = f);
        }
        return _results;
      };
      Brick.prototype._build_function = function(v) {
        var self;
        if (typeof v === 'function') {
          self = this;
          return function() {
            return v(self);
          };
        } else {
          return function() {
            return v;
          };
        }
      };
      Brick.prototype.wName = function() {
        return this._wName;
      };
      Brick.prototype.wParent = function() {
        return this._wParent;
      };
      Brick.prototype.wRoot = function() {
        return this._wRoot;
      };
      Brick.prototype.wQid = function() {
        return this._wQid;
      };
      Brick.prototype.wRun = function() {
        return this._wInit(null, '/');
      };
      Brick.prototype.wFetch = function(sel, index) {
        var mine, selkey, split;
        if (index == null) {
          index = 0;
        }
        if (sel instanceof Array) {
          selkey = sel[index];
          mine = (function() {
            switch (selkey) {
              case '/':
                return this._wRoot;
              case '.':
                return this;
              case '..':
                return this._wParent;
              default:
                return this[selkey];
            }
          }).call(this);
          if (mine != null) {
            if (sel.length - 1 === index) {
              return mine;
            } else if (mine['wFetch'] != null) {
              return mine.wFetch(sel, index + 1);
            } else {
              throw "Not a waw brick under " + (sel.join('/')) + " (" + selkey + "), unable to fetch";
            }
          } else {
            throw "No such key " + sel[index];
          }
        } else if (sel === '/') {
          return this._wRoot;
        } else {
          split = sel.split('/');
          if (split[0] === "") {
            split[0] = '/';
          }
          return this.wFetch(split, 0);
        }
      };
      Brick.prototype.wGet = function(sel) {
        var fetched;
        fetched = this.wFetch(sel);
        if ((fetched != null) && (fetched['get'] != null)) {
          return fetched.get();
        } else {
          throw "Not gettable " + sel;
        }
      };
      Brick.prototype.wSet = function(sel, value) {
        var fetched;
        fetched = this.wFetch(sel);
        if ((fetched != null) && (fetched['set'] != null)) {
          return fetched.set(value);
        } else {
          throw "Not settable " + sel;
        }
      };
      Brick.prototype.wListen = function(sel, fn) {
        var fetched;
        fetched = this.wFetch(sel);
        if ((fetched != null) && (fetched['listen'] != null)) {
          fetched.listen(fn);
        } else {
          throw "Not a listenable " + fetched;
        }
        return this;
      };
      Brick.prototype.wUnlisten = function(sel, fn) {
        var fetched;
        fetched = this.wFetch(sel);
        if ((fetched != null) && (fetched['unlisten'] != null)) {
          fetched.unlisten(fn);
        } else {
          throw "Not a listenable " + fetched;
        }
        return this;
      };
      Brick.prototype.wEmit = function() {
        var args, fetched, sel;
        sel = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        fetched = this.wFetch(sel);
        if ((fetched != null) && (fetched['emit'] != null)) {
          fetched.emit.apply(fetched, args);
        } else {
          throw "Not an emittable " + fetched;
        }
        return this;
      };
      Brick.prototype.wCall = function(sel, fn) {
        var fetched;
        fetched = this.wFetch(sel);
        if (fetched != null) {
          return fn.apply(fetched);
        } else {
          throw "Not found " + sel;
        }
      };
      return Brick;
    })();
  };
  builder['./cell'] = function(exports){
    var Brick, Cell, Signal;
    var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
      for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
      function ctor() { this.constructor = child; }
      ctor.prototype = parent.prototype;
      child.prototype = new ctor;
      child.__super__ = parent.prototype;
      return child;
    };
    Brick = require('./brick').Brick;
    Signal = require('./signal').Signal;
    exports.Cell = Cell = (function() {
      __extends(Cell, Brick);
      function Cell(_value) {
        this._value = _value;
        Cell.__super__.constructor.apply(this, arguments);
        this.changed = new Signal(this);
      }
      Cell.prototype.get = function() {
        return this._value;
      };
      Cell.prototype.set = function(value) {
        var oldval;
        oldval = this._value;
        this._value = value;
        this.changed.emit(this, oldval, value);
        return this._value;
      };
      Cell.prototype.listen = function(fn) {
        return this.wListen('changed', fn);
      };
      Cell.prototype.unlisten = function(fn) {
        return this.wUnlisten('changed', fn);
      };
      Cell.prototype.toString = function() {
        var v;
        v = this.get();
        if (v != null) {
          return v.toString();
        } else {
          return null;
        }
      };
      return Cell;
    })();
  };
  builder['./helpers'] = function(exports){
    var Helpers;
    var __slice = Array.prototype.slice;
    exports.Helpers = Helpers = (function() {
      function Helpers() {}
      Helpers.prototype.wApp = {
        onReady: [],
        running: [],
        start: function() {
          var fn, _i, _len, _ref, _results;
          _ref = $.wApp.onReady;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            fn = _ref[_i];
            _results.push($.wApp.running.push(fn()));
          }
          return _results;
        },
        ready: function(fn) {
          return $.wApp.onReady.push(fn);
        }
      };
      Helpers.prototype.wRun = function(app) {
        app.wRun();
        return app;
      };
      Helpers.prototype.wFetch = function(qid) {
        return $.wApps[0].wFetch(qid);
      };
      Helpers.prototype.wGet = function(qid) {
        return $.wApps[0].wGet(qid);
      };
      Helpers.prototype.wSet = function(qid, value) {
        return $.wApps[0].wSet(qid, value);
      };
      Helpers.prototype.wListen = function(sel, fn) {
        return $.wApps[0].wListen(sel, fn);
      };
      Helpers.prototype.wUnlisten = function(sel, fn) {
        return $.wApps[0].wUnlisten(sel, fn);
      };
      Helpers.prototype.wEmit = function() {
        var args, sel, _ref;
        sel = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        return (_ref = $.wApps[0]).wEmit.apply(_ref, [sel].concat(__slice.call(args)));
      };
      Helpers.prototype.wConnect = function(signal, slot) {
        return signal.listen(slot);
      };
      Helpers.prototype.wDisconnect = function(signal, slot) {
        return signal.unlisten(slot);
      };
      Helpers.prototype.wCall = function(qid, fn) {
        return $.wApps[0].wCall(qid, fn);
      };
      return Helpers;
    })();
  };
  builder['./signal'] = function(exports){
    var Signal;
    exports.Signal = Signal = (function() {
      function Signal(brick) {
        this.brick = brick;
        this.listeners = [];
      }
      Signal.prototype.listen = function(l) {
        this.listeners.push(l);
        return this;
      };
      Signal.prototype.unlisten = function(l) {
        var candidate, i, index, _len, _ref;
        index = null;
        _ref = this.listeners;
        for (i = 0, _len = _ref.length; i < _len; i++) {
          candidate = _ref[i];
          if (candidate === l) {
            index = i;
          }
        }
        if (index != null) {
          return this.listeners.splice(index, 1);
        }
      };
      Signal.prototype.emit = function() {
        var l, _i, _len, _ref, _results;
        _ref = this.listeners;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          l = _ref[_i];
          _results.push(l.apply(null, arguments));
        }
        return _results;
      };
      return Signal;
    })();
  };
  builder['./sm'] = function(exports){
    var Cell, SM, Signal;
    var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
      for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
      function ctor() { this.constructor = child; }
      ctor.prototype = parent.prototype;
      child.prototype = new ctor;
      child.__super__ = parent.prototype;
      return child;
    }, __slice = Array.prototype.slice, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
    Cell = require('./cell').Cell;
    Signal = require('./signal').Signal;
    exports.SM = SM = (function() {
      __extends(SM, Cell);
      function SM(def) {
        this.def = def;
        SM.__super__.constructor.apply(this, arguments);
        this.set(null);
      }
      SM.prototype.value_for = function(key) {
        return this.def[key];
      };
      SM.prototype.wInit = function(parent, name) {
        var k, v, _ref;
        _ref = this.def;
        for (k in _ref) {
          v = _ref[k];
          this.wListen(k, this._build_fn(k, v));
        }
        return this;
      };
      SM.prototype._build_fn = function(k, v) {
        if (typeof v === "function") {
          return __bind(function() {
            var _ref;
            _ref = arguments, arguments = 1 <= _ref.length ? __slice.call(_ref, 0) : [];
            return this.set(v.apply(null, arguments));
          }, this);
        } else {
          return __bind(function() {
            var _ref;
            _ref = arguments, arguments = 1 <= _ref.length ? __slice.call(_ref, 0) : [];
            return this.set(v);
          }, this);
        }
      };
      return SM;
    })();
  };
  builder['./view'] = function(exports){
    var Brick, View;
    var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
      for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
      function ctor() { this.constructor = child; }
      ctor.prototype = parent.prototype;
      child.prototype = new ctor;
      child.__super__ = parent.prototype;
      return child;
    };
    Brick = require('./brick').Brick;
    exports.View = View = (function() {
      __extends(View, Brick);
      View.prototype.defaults = {
        url: function(v) {
          return v.renderScope().wQid() + '/' + v.wName() + ".whtml";
        },
        selector: function(v) {
          return "#" + v.wName();
        },
        template: function(v) {
          var _ref;
          return (_ref = v._template) != null ? _ref : v._template = $.ajax({
            url: v.url(),
            async: false
          }).responseText;
        },
        handler: 'server',
        renderScope: function(v) {
          return v.wParent();
        },
        renderData: {},
        partials: [],
        render: function(v) {
          switch (v.handler()) {
            case 'server':
              return $.ajax({
                url: v.url(),
                async: false
              }).responseText;
            case 'mustache':
              return v.mustacheRender();
          }
        }
      };
      function View(opts) {
        this._buildPartial = __bind(this._buildPartial, this);;
        this._normalizePartials = __bind(this._normalizePartials, this);;
        this.mustacheRender = __bind(this.mustacheRender, this);;
        this.wCallRenderer = __bind(this.wCallRenderer, this);;
        this.toString = __bind(this.toString, this);;
        this.refresh = __bind(this.refresh, this);;    View.__super__.constructor.apply(this, arguments);
        this._normalizePartials(opts);
      }
      View.prototype.wInit = function(parent, name) {
        return View.__super__.wInit.apply(this, arguments);
      };
      View.prototype.refresh = function() {
        var sel;
        sel = this.selector();
        return $(sel).replaceWith(this.toString());
      };
      View.prototype.toString = function() {
        return this.render().toString();
      };
      View.prototype.wCallRenderer = function(text, render) {
        var call;
        call = render(text);
        if (call[call.length - 1] !== ')') {
          call += "()";
        }
        call = "function(){ this." + call + "; }";
        call = "$.wCall('" + (this.renderScope().wQid()) + "', " + call + ");";
        return call;
      };
      View.prototype.mustacheRender = function() {
        var callRenderer, data, l, partials, tpl, _i, _len, _ref;
        tpl = this.template();
        callRenderer = this.wCallRenderer;
        data = $.extend({}, this.renderScope(), {
          wCall: function() {
            return callRenderer;
          }
        }, this.renderData());
        partials = {};
        _ref = this.partials();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          l = _ref[_i];
          data[l.wName()] = l.render();
          partials[l.wName()] = "{{{" + (l.wName()) + "}}}";
        }
        return Mustache.to_html(tpl, data, partials);
      };
      View.prototype._normalizePartials = function(opts) {
        var normalized, p, _base, _i, _len, _ref, _ref2;
        (_ref = (_base = this.options)['partials']) != null ? _ref : _base['partials'] = [];
        normalized = [];
        _ref2 = this.options['partials'];
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          p = _ref2[_i];
          if (typeof p === "string") {
            this[p] = this._buildPartial(p, opts);
            normalized.push(this[p]);
          } else {
            normalized.push(p);
          }
        }
        return this.options['partials'] = normalized;
      };
      View.prototype._buildPartial = function(name, opts) {
        var override;
        override = {
          partials: [],
          renderScope: function(v) {
            return v.wParent().wParent();
          }
        };
        return new View($.extend({}, opts, override));
      };
      return View;
    })();
  };
  builder['./wawjs'] = function(exports){
    exports.Signal = require('./signal').Signal;
    exports.Brick = require('./brick').Brick;
    exports.Cell = require('./cell').Cell;
    exports.SM = require('./sm').SM;
    exports.View = require('./view').View;
    exports.Helpers = require('./helpers').Helpers;
    $(document).ready(function() {
      return $.extend($, new exports.Helpers);
    });
  };
  require('./wawjs');
  if (WawJS.onReady != null) {
    WawJS.start();
  }
}).call(this, WawJS);
