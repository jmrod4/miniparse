require 'test_helper'



class TestOptionInterface < Minitest::Test

  include ElementInterface
  include ElementRequeriments
  include OptionInterface

  def setup
    @obj = Option1Stub.new(spec: "--some")
    @object = Option2Stub.new(spec: "--some")
  end
  
  def test_subclass_requirements
    #assert_raises(NotImplementedError) {
    #    Miniparse::Option.spec_to_name("some") }
    #assert_raises(NotImplementedError) { @obj.arg_to_value "--some" }
    assert_raises(NotImplementedError) { @obj.help_usage }
  end
  
end



class TestOption < Minitest::Test

  def setup
    @object = Option2Stub.new(spec: "any")
  end
  
  def test_methods
    assert "stub" == @object.arg_to_value("any")  
    @object.parse_value("any")
    assert "stub" == @object.value 
  end

end