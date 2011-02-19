module IMagick
  
  # Raised when something goes wrong
  class Error < StandardError; end
  
  COMMANDS = {
    :create_thumbnail => [
      :convert, {
        :define    => "jpeg:size=200x200",
        :thumbnail => "130x130^",
        :gravity   => "center",
        :extent    => "130x130",
        :quality   => 80
      }
    ], 
    :rotate_left => [
      :convert, {
        :rotate => -90
      }
    ],
    :rotate_right => [
      :convert, {
        :rotate => 90
      }
    ]
  }
  
  # Quotes a string in double quotes for shell execution
  def quote(s)
    "\"#{s}\""
  end
  
  #
  # Runs a shell command.
  #
  # This method executes _command_ via Kernel.system. If the command
  # fails or does not return 0 as status code a IMagick::Error is 
  # raised. Otherwise, the method returns true.
  #
  def shell_exec(command)
    command yield(command) if block_given?
    if Kernel.system(command)
      true
    else
      raise Error, "Error (#{$?}):\n  #{command}"
    end
  end
  
  # 
  # Builds a string for a command with options.
  #
  def command_str_for(*args)
    args.collect{|arg|
      case arg
      when Array
        arg.join(' ')
      when Hash
        arg.collect{|k,v| "-#{k} #{v}"}.join(' ')
      else
        arg.to_s
      end
    }.join(' ')
  end
  
  #
  # Convenient method for calling command_str_for on a command 
  # whose options are in COMMANDS hash.
  #
  # Additional arguments may be passed in _args_.
  #
  def command_for(name, *args)
    command_str_for(*(COMMANDS[name] + args))
  end
  
  #
  # Executes a command whose name is given as a symbol.
  #
  # Additional arguments may be passed in _args_.
  #
  def command_exec(name, *args)
    shell_exec command_for(name, *args)
  end
  
  #
  # Creates a thumbnail from a source image and save result
  # in target image. Both path are expected to be absolute 
  # paths.
  #
  def create_thumbnail(source, target)
    command_exec(:create_thumbnail, [quote(source), quote(target)])
  end
  
  #
  # Rotates an image leftside
  #
  def rotate_left(source, target = source)
    command_exec(:rotate_left, [quote(source), quote(target)])
  end
  
  #
  # Rotates an image rightside
  #
  def rotate_right(source, target = source)
    command_exec(:rotate_right, [quote(source), quote(target)])
  end
  
  extend(IMagick)
end # module IMagick