module Miniparse



# error exit codes
ERR_HELP_REQ = 1
ERR_ARGUMENT = 2


@@behaviour_controls = { 
  error_unrecognized: true, 
  autonegatable: true,
  catch_argument_error: true,
  global_args: true,
  
  # help output
  formatted_help: true,
  detailed_usage: true,
  width_display: 79,
  width_indent: 3,
  width_left: 18,
  
  # TODO FEATURE consider using auto short options
  autoshort: false,
  }

def self.control
  @@behaviour_controls
end

def self.set_control(opts)
  @@behaviour_controls.merge!(opts)
end



end
