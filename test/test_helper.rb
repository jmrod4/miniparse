require 'minitest/pride'
require 'minitest/autorun'
require 'miniparse'

Miniparse.set_control(catch_argument_error: false)


# FIXME integrate automatic tests for the examples

def echo(obj)
  puts "---->#{obj.inspect}<-----"
end
