module Miniparse

# @return [void]
def self.reset_default_controls 
  @behaviour_controls = {}
  @behaviour_controls.merge! DEFAULT_CONTROLS
end

self.reset_default_controls

# TODO consider raising SyntaxError with a custom msg instead of KeyError

# @param key [symbol] must be a known control, if not it raises a KeyError
# @return [boolean] the current value of specified control
def self.control(key)
  @behaviour_controls.fetch(key)
end

# sets the control values specified in the hash, modern abbreviated notation can 
# be used like e.g.
#
#     set_control(autoshortable: true)
#     set_control(autoshortable: true, autonegatable: true)
#
# @param opts [hash] must contain only known controls, if not it raises a KeyError
# @return [void]
def self.set_control(opts = {})
  opts.keys.each  { |key|  @behaviour_controls.fetch key }
  @behaviour_controls.merge! opts
end



end
