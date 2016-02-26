require 'minitest/pride'
require 'minitest/autorun'
require 'miniparse'

Miniparse.set_control(raise_argument_error: true)


def echo(obj)
  puts "---->#{obj.inspect}<-----"
end
