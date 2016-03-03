require 'minitest/pride'
require 'minitest/autorun'
require 'miniparse'

Miniparse.set_control(
  error_on_unrecognized: true, 
  rescue_argument_error: false,
  help_cmdline_empty: false,
  raise_global_args: false,
  )


# FIXME integrate automatic tests for the examples

def echo(obj)
  puts "---->#{obj.inspect}<-----"
end
