require 'test_helper'

module InterfaceElementInterface
  
  def test_interface_element_methods
    assert_respond_to @object, :name
    assert_respond_to @object, :post_initialize
    assert_respond_to @object, :run
    assert_respond_to @object, :help_desc
    assert_respond_to @object, :check
  end
  
  def test_interface_element_class_methods
    assert_respond_to @object.class, :spec_pattern_to_name
    assert_respond_to @object.class, :spec_to_name
    assert_respond_to @object.class, :valid_spec
  end

end



module InterfaceElementRequeriments

  def test_implement_class_methods
     @object.class.spec_to_name "some"
  end
  
  def test_implement_methods
     @object.check "some"
  end 

end  



class ElementStub < Miniparse::InterfaceElement
  def self.spec_to_name(spec)
    :stub
  end
end



class TestInterfaceElementInterface < Minitest::Test
  
  def setup
    @object = ElementStub.new spec:"some"
  end
  
  include InterfaceElementInterface
  
  def test_subclass_requirements
    assert_raises(NotImplementedError) {
        Miniparse::InterfaceElement.spec_to_name "some" }
    assert_raises(NotImplementedError) {
        @object.check "some" }
  end
        
  def test_parser_respond
    assert_respond_to Miniparse::InterfaceElement, :spec_pattern_to_name
  end
  
  def test_required_argument
    assert_raises(KeyError) { 
        Miniparse::InterfaceElement.new({}) }
    assert_raises(KeyError) { 
        Miniparse::InterfaceElement.new desc:"some desc" }
  end

end



class TestCommandInterface < Minitest::Test

  def setup
    @object = Miniparse::Command.new spec:"some"
  end
  
  include InterfaceElementInterface
  include InterfaceElementRequeriments
    
end




module OptionRequeriments

  def test_implement_methods
     @object.arg_to_value "--some"
  end 

end



class OptionStub < Miniparse::Option
  def self.spec_to_name(spec)
    :stub
  end
end
class Option2Stub < Miniparse::Option
  def self.spec_to_name(spec)
    :stub
  end
  def arg_to_value arg
    "stub"
  end
end



class TestOptionInterface < Minitest::Test
  def setup
    @object = Option2Stub.new spec:"--some"
  end
  
  include InterfaceElementInterface
  include InterfaceElementRequeriments
  
  def test_subclass_requirements
    assert_raises(NotImplementedError) {
        Miniparse::Option.spec_to_name "some" }
    assert_raises(NotImplementedError) {
        OptionStub.new(spec:"--some").arg_to_value "--some" }
  end
  
  def test_option_interface
    assert_respond_to @object, :value
    assert_respond_to @object, :arg_to_value
    assert_respond_to @object, :parse_value
  end
end



class TestSwitchInterface < Minitest::Test
  def setup
    @object = Miniparse::SwitchOption.new spec:"--some"
  end
  
  include InterfaceElementInterface
  include InterfaceElementRequeriments
  include OptionRequeriments

  def test_switch_option_interface
    assert_respond_to @object, :help_usage   
  end
end



class TestFlagInterface < Minitest::Test
  def setup
    @object = Miniparse::FlagOption.new spec:"--some SOME"
  end
  
  include InterfaceElementInterface
  include InterfaceElementRequeriments
  include OptionRequeriments

  def test_flag_option_interface
    assert_respond_to @object, :help_usage   
  end
end


