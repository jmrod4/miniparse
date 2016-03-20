# example from the project readme
    
require 'miniparse'

# following is just a copy of the controls defined in constants.rb
# you don't need to specify all, only the ones you want to change (maybe none)

Miniparse.set_control( {
    # gives an error if there is an unrecognized option either short or long
    # (if not then passes them as arguments) 
    raise_on_unrecognized: true, 
    
    # intercepts .parse ArgumentError (i.e. the commandline user introduced 
    # wrong or invalid options) and exits with a helpful msg  
    rescue_argument_error: true,
    
    # gives usage help and exits if commandline is empty
    # useful if your app always needs args or options to work
    help_cmdline_empty: false,
    
    # raises an ArgumentError if there are global args 
    # (after parsing options and commands)
    # useful if you don't expect any args
    raise_global_args: false,

    # formats help output with the width_... controls
    formatted_help: true,
    
    width_display: 79,
    width_indent: 3,
    width_left: 18,
    
    # use a detailed options help usage msg or a generic one
    detailed_usage: true,

    # uses --no-... options for all options
    # useful if you want all your options to be negatable by default
    autonegatable: false,
    
    # uses short options (besides long ones) for all options
    # useful if you want all your options to be shortable by default
    autoshortable: false,
    } )


parser = Miniparse::Parser.new("does something wonderful")
parser.add_option "--debug", "activate debugging"
parser.parse ARGV

if parser.options[:debug]
  puts "DEBUG ACTIVATED!"
else
  puts "run silently"
end

# show results with the current used command line
# for global options
puts "args     #{parser.args.inspect}"
puts "options  #{parser.options.inspect}"
# for commands
puts "parsed command  #{parser.command_name.inspect}"
puts "command args    #{parser.command_args.inspect}"
puts "command options #{parser.command_options.inspect}"