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

    def headize(name)
      <<-EOF.gsub(/^\s*\| /m, "")
      | var #{name} = function(){};
      | (function(exports) {
      |   var builder, require;
      |   builder = [];
      |   require = function(name) {
      |     var _ref;
      |     (_ref = exports[name]) != null ? _ref : exports[name] = builder[name](exports);
      |     return exports;
      |   };
      EOF
    end
    
    def terminize(name)
      <<-EOF.gsub(/^\s*\| /m, "")
      |   require('./#{name.downcase}');
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
      code += headize(name)
      if join
        code += join_compile(srcfolder).gsub(/^/m, '  ')
      else
        code += nojoin_compile(srcfolder).gsub(/^/m, '  ')
      end
      code += terminize(name)
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