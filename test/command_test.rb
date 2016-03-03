require 'test_helper'


class TestCommandInterface < Minitest::Test

  include ElementInterface
  include ElementRequeriments

  def setup
    @object = Miniparse::Command.new spec:"some"
  end
    
end


class TestCommand < Minitest::Test
  
  def test_class_methods
    assert :list == Miniparse::Command.spec_to_name("list")
    assert_nil Miniparse::Command.spec_to_name("list raw")
    assert_nil Miniparse::Command.spec_to_name("list ")
    assert_nil Miniparse::Command.spec_to_name(" list")
    
    assert Miniparse::Command.valid_spec("list")
    refute Miniparse::Command.valid_spec("list raw")
    refute Miniparse::Command.valid_spec("list ")
    refute Miniparse::Command.valid_spec(" list")
  end
  
  def test_check
    cmd = Miniparse::Command.new spec: "list"
    assert cmd.check "list"
    refute cmd.check "LIST"
    refute cmd.check "List"
    refute cmd.check "list "
    refute cmd.check " list "
    refute cmd.check "list raw"
  end
end
