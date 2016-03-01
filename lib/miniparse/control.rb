module Miniparse



# error exit codes
ERR_HELP_REQ = 1
ERR_ARGUMENT = 2


@@behaviour_controls = {
  # gives an error if there is an unrecognized option either short or long
  # (if not then passes it as an argument) 
  error_unrecognized: true, 
  
  # intercepts and exits with a polite msg if there is an ArgumentError 
  # (i.e. the command line user introduced wrong or invalid options)
  rescue_argument_error: true,
  
  # if false raises an 
  global_args: true,

  # format help output with the width... controls
  formatted_help: true,
  width_display: 79,
  width_indent: 3,
  width_left: 18,
  
  # use a generic help usage msg or a specific one
  detailed_usage: true,

  # uses --no-... options for all options
  autonegatable: true,
  
  # TODO FEATURE consider implementing (auto) short options
  # uses short options (besides long ones) for all options
  autoshortable: false,
  }

def self.control
  @@behaviour_controls
end

def self.set_control(opts)
  @@behaviour_controls.merge!(opts)
end



end
