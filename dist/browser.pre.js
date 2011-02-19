/**
 * wAw.js micro web framework v1.0.0
 * http://github.com/blambeau/waw.js
 *
 * Copyright 2011, Bernard Lambeau
 * Released under the MIT License
 */
(function(exports) {
	var builder, require;
	builder = {};
	require = function(name) {
	  var _ref;
	  (_ref = exports[name]) != null ? _ref : exports[name] = builder[name](exports);
	  return exports;
	};
