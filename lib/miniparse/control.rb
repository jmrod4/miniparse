module Miniparse



# error exit codes
ERR_HELP_REQ = 1
ERR_ARGUMENT = 2


@@behaviour_controls = {
  # gives an error if there is an unrecognized option either short or long
  # (if not then passes them as arguments) 
  error_on_unrecognized: true, 
  
  # intercepts .parse ArgumentError (i.e. the command line user introduced 
  # wrong or invalid options) and exits with a helpful msg  
  rescue_argument_error: true,
  
  # gives help if command line is empty
  help_cmdline_empty: true,
  
  # raises an ArgumentError if there are global args 
  # (after parsing options and commands)
  raise_global_args: true,

  # formats help output with the width... controls
  formatted_help: true,
  width_display: 79,
  width_indent: 3,
  width_left: 18,
  
  # use a generic help usage msg or a specific one
  detailed_usage: true,

  # uses --no-... options for all options
  autonegatable: true,
  
  # uses short options (besides long ones) for all options
  autoshortable: true,
  }


# TODO consider raising SyntaxError with a custom msg instead of KeyError
def self.control(key)
  # raises a KeyError if key missing
  @@behaviour_controls.fetch(key)
end

def self.set_control(opts = {})
  # raises a KeyError if any key missing
  opts.keys.each  { |key|  @@behaviour_controls.fetch key }
  @@behaviour_controls.merge! opts
end



end
