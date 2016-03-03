module OptionInterface

  def test_option_accessors
    assert @object.respond_to? :value
    assert @object.respond_to? :shortable
  end  
  
  def test_opton_methods  
    assert @object.respond_to? :parse_value
    assert @object.respond_to? :arg_to_value
    assert @object.respond_to? :help_usage
  end

end

module OptionRequeriments

  def test_implement_methods
     @object.arg_to_value "--some"
     @object.help_usage
  end 

end