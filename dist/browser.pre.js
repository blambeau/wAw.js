var Waw = function(){};
(function(exports) {
	var builder, require;
	builder = [];
	require = function(name) {
	  var _ref;
	  (_ref = exports[name]) != null ? _ref : exports[name] = builder[name](exports);
	  return exports;
	};
