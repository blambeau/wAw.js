class WawJS::Commands::Main
  #
  # Compile a waw.js application 
  #
  # SYNOPSIS
  #   #{program_name} [--help] [--version] [SRC]
  #
  # OPTIONS
  # #{summarized_options}
  #
  # DESCRIPTION
  #   Compiles a waw.js application located in SRC folder
  #
  class Compile < Quickl::Command(__FILE__, __LINE__)
  
    # Lowercase name of the application to compile
    attr_accessor :name
  
    # Which header file to use
    attr_accessor :header
  
    # Uglify result?
    attr_accessor :uglify
  
    # Join coffee script before compilation?
    attr_accessor :join
  
    # Install command options
    options do |opt|
      @name = "app"
      opt.on('--name=NAME', "Set an application name"){|value| 
        @name = value
      }
      @header = nil
      opt.on('--header=FILE', "Insert a (licensing) header file"){|value| 
        @header = value
      }
      @join = true
      opt.on("-j", "--[no-]join", "Join coffee scripts before compilation"){|value| 
        @join = value
      }
      @uglify = false
      opt.on('-u', '--[no-]uglify', "Minimize generated javascript (requires uglifyjs)"){|value| 
        @uglify = value
      }
    end
  
    def _(file)
      File.expand_path("../../#{file}", __FILE__)
    end
    
    # Runs a command, returns result on STDOUT. If the exit status was no 0,
    # a RuntimeError is raised. 
    def safe_run(cmd)
      res = `#{cmd}`
      unless $?.exitstatus == 0
        raise RuntimeError, "Error while executing #{cmd}" 
      end
      res
    end
  
    def do_uglify(code)
      require "tempfile"
      file = Tempfile.new('waw.js.code')
      file << code
      file.close
      code = safe_run("uglifyjs #{file.path}")
      file.unlink
      code
    end
    
    def with_coffee_application_header(name) 
      code = ""
      code += <<-EOF.gsub(/^\s*\| /m, "")
      | #{name} ?= {
      |   onReady: []
      |   start: ->
      |     for fn in #{name}.onReady
      |       fn()
      |   ready: (fn)-> 
      |     #{name}.onReady.push fn
      | }
      EOF
      code += yield
      code += <<-EOF.gsub(/^\s*\| /m, "")
      | if #{name}.onReady? 
      |   #{name}.start()
      EOF
    end
    
    def with_js_application_header(name)
      code = ""
      code += <<-EOF.gsub(/^\s*\| /m, "")
      | var #{name};
      | (_ref = #{name}) != null ? _ref : #{name} = {
      |   onReady: [],
      |   start: function() {
      |     var fn, _i, _len, _ref, _results;
      |     _ref = #{name}.onReady;
      |     _results = [];
      |     for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      |       fn = _ref[_i];
      |       _results.push(fn());
      |     }
      |     return _results;
      |   },
      |   ready: function(fn) {
      |     return #{name}.onReady.push(fn);
      |   }
      | };
      | (function(exports) {
      |   var builder, require;
      |   builder = [];
      |   require = function(name) {
      |     var _ref;
      |     (_ref = exports[name]) != null ? _ref : exports[name] = builder[name](exports);
      |     return exports;
      |   };
      EOF
      code += yield.gsub(/^/m, '  ')
      code += <<-EOF.gsub(/^\s*\| /m, "")
      |   require('./#{name.downcase}');
      |   if (#{name}.onReady != null) {
      |     #{name}.start();
      |   }
      | }).call(this, #{name});
      EOF
    end

    def with_builder(name)
      code = ""
      code += "builder['./#{name}'] = function(exports){\n"
      code += yield.gsub(/^/m, '  ')
      code += "};\n"
    end

    def nojoin_compile(srcfolder)
      code = ""
      Dir["#{srcfolder}/**/*.coffee"].each do |file|
        code += with_builder(File.basename(file, '.coffee')){
          safe_run("cat #{file} | coffee --compile --bare --stdio")
        }
      end
      code
    end
    
    def coffee_files_in_order(srcfolder)
      files = Dir["#{srcfolder}/**/*.coffee"]
      files.sort{|f1,f2| f1.split('/').size <=> f2.split('/').size}
      files
    end
  
    def join_compile(srcfolder)
      files = coffee_files_in_order(srcfolder)
      with_builder(name){
        safe_run("cat #{files.join(' ')} | coffee --compile --bare --stdio --join")
      }
    end

    def compile(srcfolder)
      code = ""
      code += File.read(@header) if @header
      code += with_js_application_header(name){
        if join
          join_compile(srcfolder)
        else
          nojoin_compile(srcfolder)
        end
      }
      code = do_uglify(code) if uglify
      code
    end
  
    def with_output
      yield(STDOUT)
    end

    # Execute the command on some arguments
    def execute(args)
      if args.size == 1
        with_output{|io| io << compile(args[0])}
      else
        raise Quickl::Help
      end
    end
  
  end # class Compile
end # module WawJS::Commands::Main