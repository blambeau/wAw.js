require "rubygems"
require "sinatra/base"
module WawJS
  class Brick < Sinatra::Base
    
    # def self.method_added(name)
    #   super
    #   return if @busy
    #   @busy = true
    #   meth = instance_method(name)
    #   get "/#{name}" do
    #     begin
    #       meth.bind(self).call(params)
    #     rescue => ex
    #       ex.message
    #     end
    #   end
    #   @busy = false
    # end

  end # class Brick
end # module WawJS 
