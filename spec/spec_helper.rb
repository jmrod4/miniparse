$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'miniparse'

module Helper

  @@old_control_values = [] 

  def self.push_control(key, value)
    pair = { key => Miniparse::control(key) }
    @@old_control_values << pair
    Miniparse.set_control(key => value)
  end


  def self.pop_control
    Miniparse.set_control(@@old_control_values.pop)
  end

end
