$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'miniparse'

@@old_control_values = [] 

def push_control(key, value)
  pair = { key => Miniparse::control(key) }
  @@old_control_values << pair
  Miniparse.set_control(key => value)
end


def pop_control
  Miniparse.set_control(@@old_control_values.pop)
end