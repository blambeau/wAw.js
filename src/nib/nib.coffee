Nib = {
  
  #
  # Package builders.
  #
  # Package builders are simply unary functions registered via Nib.define. 
  # These functions are expected to build the package thanks to a Builder 
  # instance that they receive as first argument.
  #
  # @see define
  # @see Builder
  #
  pkgBuilders: []

  # 
  # Built packages.
  #
  # Once the package are built (lazily, at first 'require' invocation), the
  # results is put in the following array for subsequent requiring.
  #
  packages: []

  #
  # Defines a package via a name and a builder function. 
  #
  # Builder functions are expected to build the package thanks to a Builder
  # instance received as first argument. They are expected to make the first
  # require to the package index file.
  #
  # Example:
  #   Nib.define('foo', function(nib){
  #     nib.register('bar', function(exports, require){
  #       /* content of bar.js comes here */
  #     });
  #     nib.register('index', function(exports, require){
  #       /* content of index.js come here */
  #     });
  #     /* Load the package at end */
  #     nib.require('index');
  #   });
  #
  define: (name, buildFn)->
    Nib.pkgBuilders[name] = buildFn
  
  #
  # Returns a package, building it if required (equivalent to Node's _require_).
  #
  # Example:
  #   Foo = Nib.require('foo')
  #   Foo.Bar = ...
  #
  require: (name)->
    Nib.packages[name] ?= Nib.pkgBuilders[name](new Builder())

  # Application control
  pending: []

  running: []

  ready: (fn)->
    Nib.pending.push(fn)

  start: ()->
    for fn in Nib.pending
      Nib.running.push(fn())
    Nib.pending = []

  isRunning: (fn)->
    for c in Nib.running
      return true if c is fn
    return false
    
}

#
# Intra-package builder, passed as first argument of Nib.define
#
# This builder helps registrering functions for building individual
# files, as well as requiring them.
#
class Builder

  #
  # Builds a builder instance
  #
  constructor: ()->
    @builders = []
    @built = []

  #
  # Register a builder function for _file_.
  #
  # The builder function will be called when the file will be required later. 
  # It takes two parameters as arguments, exports and require. The first one 
  # allows the file to exports artifacts while the second one mimics the 
  # Node's require function.
  #
  register: (file, builder)=>
    @builders[file] = builder

  #
  # Mimics Node's require in the context of this building.
  #
  # This function returns the result of requiring _file_, building it with 
  # the function previously registered (if not previously done).
  #
  require: (file)=>
    @built[file] ?= this.build_file(file)
  
  #
  # Private functions that ensures the building of a file.
  #
  build_file: (file)=>
    exports = {}
    @builders[file](exports, this.require)
    exports

# Main export
exports.Nib = Nib