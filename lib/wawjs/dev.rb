require 'wawjs'
require 'wawjs/no_cache'
require 'wawjs/commands/main'
require 'wawjs/commands/compile'
module WawJS
  class Dev < Sinatra::Base
    
    VENDOR_JS = File.expand_path('../../../vendor/js', __FILE__)
    
    def initialize(configru)
      super
      @app_root = if File.file?(configru)
        File.expand_path File.dirname(configru)
      elsif File.directory?(configru)
        File.expand_path configru
      else
        raise "Not a file or directory: #{configru}"
      end
      @locations = [ 
        File.join(@app_root, 'vendor', 'js'),
        File.join(@app_root, 'src', 'public', 'js'),
        VENDOR_JS
      ]
    end
    
    def exists_in(libname, location)
      look = File.join(location, "#{libname}*.js")
      Dir[look].sort.last
    end
    
    def look_for(libname)
      @locations.each do |loc|
        found = exists_in(libname, loc)
        return found unless found.nil?
      end
      nil
    end
    
    def compile_app(name)
      c = WawJS::Commands::Main::Compile.new
      c.name = name
      c.join = true
      c.uglify = false
      c.compile(File.join(@app_root, 'src'))
    end
    
    def join_app(libname)
      c = WawJS::Commands::Main::Compile.new
      source = []
      c.coffee_files_in_order(File.join(@app_root, 'src')).each{|f|
        source << File.read(f)
        source << "\n"
      }
      source
    end
    
    get %r{([\w\-]+).js$} do
      libname = params[:captures].first
      if file = look_for(libname)
        send_file file
      elsif libname == File.basename(@app_root)
        headers NoCache::NO_CACHE_HEADERS.merge("Content-Type" => "text/javascript")
        compile_app(libname)
      else
        not_found
      end
    end

    get %r{([\w\-]+).coffee$} do
      libname = params[:captures].first
      if libname == File.basename(@app_root)
        headers NoCache::NO_CACHE_HEADERS.merge("Content-Type" => "text/coffeescript")
        join_app(libname)
      else
        not_found
      end
    end
    
  end # class Dev
end # module WawJS