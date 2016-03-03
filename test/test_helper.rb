require 'minitest/pride'
require 'minitest/autorun'
require 'miniparse'
require 'element_module'
require 'option_module'


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



class ElementStub < Miniparse::InterfaceElement
  def self.spec_to_name(spec)
    :stub
  end
end


class Option1Stub < Miniparse::Option
  def self.spec_to_name(spec)
    :stub
  end
end

class Option2Stub < Option1Stub
  def arg_to_value(arg)
    "stub"
  end
end

