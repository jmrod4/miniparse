require 'minitest/pride'
require 'minitest/autorun'
require 'miniparse'

Miniparse.set_control(
  rescue_argument_error: false,
  raise_global_args: false,
  )


# FIXME integrate automatic tests for the examples

def echo(obj)
  puts "---->#{obj.inspect}<-----"
end
