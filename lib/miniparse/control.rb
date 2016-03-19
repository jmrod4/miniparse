module Miniparse



def self.reset_controls 
  @behaviour_controls = {}
  @behaviour_controls.merge! DEFAULT_CONTROLS
end

self.reset_controls

# raises a KeyError if key is not a recognized control
# TODO consider raising SyntaxError with a custom msg instead of KeyError
def self.control(key)
  @behaviour_controls.fetch(key)
end

# raises a KeyError if any key is not a recognized control
def self.set_control(opts = {})
  opts.keys.each  { |key|  @behaviour_controls.fetch key }
  @behaviour_controls.merge! opts
  nil
end



end
