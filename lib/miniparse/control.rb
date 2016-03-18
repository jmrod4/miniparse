module Miniparse



@behaviour_controls = {
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
  }

# raises a KeyError if key is not a recognized control
# TODO consider raising SyntaxError with a custom msg instead of KeyError
def self.control(key)
  @behaviour_controls.fetch(key)
end

# raises a KeyError if any key is not a recognized control
def self.set_control(opts = {})
  opts.keys.each  { |key|  @behaviour_controls.fetch key }
  @behaviour_controls.merge! opts
  nil
end



end
