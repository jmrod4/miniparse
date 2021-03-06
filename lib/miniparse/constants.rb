
module Miniparse

  ERR_HELP_REQ = 1
  ERR_ARGUMENT = 2
  

  DEFAULT_CONTROLS = {
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
    
    # TODO: consider adding following control
    # admits -h besides --help in help predefined option
    # shortable_help: false,
    }

end
