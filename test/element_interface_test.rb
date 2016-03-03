require 'test_helper'


module ElementInterface
  
  def test_element_interface
    assert @object.class.respond_to? :valid_spec
    assert @object.class.respond_to? :spec_to_name
    assert @object.class.private_methods.include?(:spec_pattern_to_name)
    assert @object.respond_to? :name
    assert @object.respond_to? :run
    assert @object.respond_to? :check
    assert @object.respond_to? :help_desc
  end

  def test_element_subclass_interface
    assert @object.respond_to? :post_initialize, true
    assert @object.respond_to? :add_desc, true
  end
  
end

module ElementRequeriments

  def test_implement_element_class_methods
     @object.class.spec_to_name "some"
  end
  
  def test_implement_element_methods
     @object.check "some"
  end 

end  

class ElementStub < Miniparse::InterfaceElement
  def self.spec_to_name(spec)
    :stub
  end
end


class TestElementInterface < Minitest::Test
  
  include ElementInterface

  def setup
    @object = ElementStub.new spec: "some"
  end
  
  def test_subclass_requirements
    assert_raises(NotImplementedError) {
                 Miniparse::InterfaceElement.spec_to_name("some") }
    assert_raises(NotImplementedError) { @object.check "some" }
  end
        
  def test_required_argument
    assert_raises(KeyError) { Miniparse::InterfaceElement.new({}) }
    assert_raises(KeyError) { Miniparse::InterfaceElement.new desc:"some desc" }
  end

end


class TestCommandInterface < Minitest::Test

  include ElementInterface
  include ElementRequeriments

  def setup
    @object = Miniparse::Command.new spec:"some"
  end
    
end


module OptionInterface

  def test_option_interface
    assert @object.respond_to? :value
    assert @object.respond_to? :parse_value
    assert @object.respond_to? :arg_to_value
  end

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

  include ElementInterface
  include ElementRequeriments
  include OptionInterface

  def setup
    @object = Option2Stub.new spec:"--some"
  end
  
  def test_subclass_requirements
    assert_raises(NotImplementedError) {
        Miniparse::Option.spec_to_name("some") }
    assert_raises(NotImplementedError) {
        OptionStub.new(spec:"--some").arg_to_value "--some" }
  end
  
end


class TestSwitchInterface < Minitest::Test

  include ElementInterface
  include ElementRequeriments
  include OptionInterface
  include OptionRequeriments

  def setup
    @object = Miniparse::SwitchOption.new spec:"--some"
  end
  
  def test_switch_interface
    assert @object.respond_to? :help_usage   
  end
end


class TestFlagInterface < Minitest::Test

  include ElementInterface
  include ElementRequeriments
  include OptionInterface
  include OptionRequeriments

  def setup
    @object = Miniparse::FlagOption.new spec:"--some SOME"
  end

  def test_flag_interface
    assert @object.respond_to? :help_usage   
  end
end


