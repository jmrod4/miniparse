require 'test_helper'


class TestElementInterface < Minitest::Test
  
  include ElementInterface

  def setup
    @object = ElementStub.new(spec: "some")
  end
  
end


class TestElement < Minitest::Test
  
  def test_class_methods
    assert ElementStub.valid_spec("some")    
  end
 
  def test_initialize
    assert_raises(KeyError) { Miniparse::Command.new({}) }
    assert_raises(KeyError) { Miniparse::Command.new desc: "some desc" }
  end
  
  def test_run_block
    a = 1
    element = ElementStub.new(spec: "some") { a = 2 }
    a = 3
    element.run
    assert_equal 2, a
  end

  def test_help_desc
    element = ElementStub.new(
        spec: "someopt",
        desc: "something about some option")
    assert (element.help_desc =~ /someopt\s.*something.+some/)
  end

end


