#
# wawjs - Thinking web applications differently
#
# SYNOPSIS
#   #{program_name} [--version] [--help] COMMAND [cmd opts] ARGS...
#
# OPTIONS
# #{summarized_options}
#
# COMMANDS
# #{summarized_subcommands}
#
# DESCRIPTION
#   This is the main command of waw.js, a heavy client web framework. Subcommands
#   helps you generating and compiling waw.js web applications 
#
# See '#{program_name} help COMMAND' for more information on a specific command.
#
require "quickl"
require 'wawjs'
module WawJS
  module Commands
    class Main < Quickl::Delegator(__FILE__, __LINE__)

      # Install options
      options do |opt|
    
        # Show the help and exit
        opt.on_tail("--help", "Show help") do
          raise Quickl::Help
        end

        # Show version and exit
        opt.on_tail("--version", "Show version") do
          raise Quickl::Exit, "#{program_name} #{WawJS::VERSION} (c) 2011, Bernard Lambeau"
        end

      end
    end # class Main
  end # module Commands
end # class WawJS
require 'wawjs/commands/help'
require 'wawjs/commands/compile'