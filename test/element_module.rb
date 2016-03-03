module ElementInterface
  
  def test_element_class_methods
    assert @object.class.respond_to? :valid_spec
    assert @object.class.respond_to? :spec_to_name
  end
  
  def test_element_accessors
    assert @object.respond_to? :name
    assert @object.respond_to? :desc
  end
  
  def test_element_methods
    assert @object.respond_to? :run
    assert @object.respond_to? :check
    assert @object.respond_to? :help_desc
  end

  def test_element_subclass_interface
    assert @object.class.respond_to? :spec_pattern_to_name, true
    assert @object.respond_to? :post_initialize, true
    assert @object.respond_to? :add_desc, true
    assert @object.respond_to? :add_spec, true
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
