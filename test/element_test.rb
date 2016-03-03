require 'test_helper'


class ElementStub < Miniparse::InterfaceElement
  def self.spec_to_name(spec)
    :stub
  end
end


class TestElement < Minitest::Test
  
  def test_class_methods
    assert_equal :name,
        Miniparse::InterfaceElement.send(:spec_pattern_to_name, "somenamein", /(name)/)  
  end
  
  def test_run_block
    a = 1
    element = ElementStub.new(spec:"some") { a = 2 }
    a = 3
    element.run
    assert_equal 2, a
  end

  def test_help_desc
    element = ElementStub.new(
        spec:"someopt",
        desc:"something about some option")
    assert element.help_desc =~ /someopt/
    assert element.help_desc =~ /something.+some/
  end

end


class TestCommand < Minitest::Test
  
  def test_class_methods
    assert_equal :list, Miniparse::Command.spec_to_name("list")
    assert_nil Miniparse::Command.spec_to_name("list raw")
    assert_nil Miniparse::Command.spec_to_name("list ")
    assert_nil Miniparse::Command.spec_to_name(" list")
  end
  
  def test_check
    cmd = Miniparse::Command.new spec:"list"
    assert cmd.check "list"
    refute cmd.check "LIST"
    refute cmd.check "List"
    refute cmd.check "list "
    refute cmd.check " list "
    refute cmd.check "list raw"
  end
end



class TestOption < Minitest::Test

end



class TestOptionSwitch < Minitest::Test

  def test_class_methods
    assert_equal :list, Miniparse::SwitchOption.spec_to_name("--list")
    assert_nil Miniparse::SwitchOption.spec_to_name(" --list")
    assert_nil Miniparse::SwitchOption.spec_to_name("--list ")
    assert_nil Miniparse::SwitchOption.spec_to_name("-list")
    assert_nil Miniparse::SwitchOption.spec_to_name("-l")
  end

  def test_check
    opt = Miniparse::SwitchOption.new spec:"--debug", 
          negatable: true, shortable: false
    assert opt.check "--debug"
    assert opt.check "--no-debug"
    refute opt.check "--DEBUG"
    refute opt.check "--debu"
    refute opt.check "-debug"
    refute opt.check "debug"
    refute opt.check "-d"
    opt = Miniparse::SwitchOption.new spec:"--debug", negatable: false
    assert opt.check "--debug"
    refute opt.check "--no-debug"
  end
  
  def test_check_shortable
    opt = Miniparse::SwitchOption.new spec:"--debug", 
          negatable: true, shortable: true
    assert opt.check "-d"
  end
  
  def test_arg_to_value
    opt = Miniparse::SwitchOption.new spec:"--debug", negatable: true 
    assert_equal true, opt.arg_to_value("--debug")
    assert_equal false, opt.arg_to_value("--no-debug")
    assert_equal nil, opt.arg_to_value("debug")
    opt = Miniparse::SwitchOption.new spec:"--debug", negatable: false
    assert_equal true, opt.arg_to_value("--debug")
    assert_equal nil, opt.arg_to_value("--no-debug")
    assert_equal nil, opt.arg_to_value("debug")
  end
  
  def test_help_usage
    opt = Miniparse::SwitchOption.new spec:"--debug", negatable: true 
    refute opt.help_usage.include? "--debug" 
    assert opt.help_usage.include? "--[no-]debug" 
    opt = Miniparse::SwitchOption.new spec:"--debug", negatable: false
    assert opt.help_usage.include? "--debug" 
    refute opt.help_usage.include? "--[no-]debug" 
  end

end



class TestOptionFlag < Minitest::Test

  def test_class_methods
    assert_equal :list, Miniparse::FlagOption.spec_to_name("--list VALUE")
    assert_equal :list, Miniparse::FlagOption.spec_to_name("--list=VALUE")

    assert_nil Miniparse::FlagOption.spec_to_name("--list")
    assert_nil Miniparse::FlagOption.spec_to_name("--list ")
    assert_nil Miniparse::FlagOption.spec_to_name("--list ")
    assert_nil Miniparse::FlagOption.spec_to_name("-l VALUE")
    assert_nil Miniparse::FlagOption.spec_to_name("-list VALUE")
  end

  def test_check
    opt = Miniparse::FlagOption.new spec: "--debug LEVEL", shortable: false

    assert opt.check "--debug 1"
    assert opt.check "--debug=1"
    assert opt.check "--debug hard"
    assert opt.check "--debug hard pressed"
    assert opt.check "--debug"
    refute opt.check "--no-debug 1"
    refute opt.check "--DEBUG 1"
    refute opt.check "--debu 1"
    refute opt.check "-debug 1"
    refute opt.check "-d 1"
    refute opt.check "debug 1"
    refute opt.check "debug=1"
  end
  
  def test_check_shortable
    opt = Miniparse::FlagOption.new spec: "--debug LEVEL", shortable: true
    assert opt.check "-d 1"
  end
  
  def test_arg_to_value
    opt = Miniparse::FlagOption.new spec:"--debug LEVEL"
    assert_equal "1", opt.arg_to_value("--debug 1")
    assert_equal "1", opt.arg_to_value("--debug=1")
    assert_equal nil, opt.arg_to_value("--debug")
    assert_equal nil, opt.arg_to_value("--debug=")
    assert_equal nil, opt.arg_to_value("--debug ")
    assert_equal " ", opt.arg_to_value("--debug  ")
    assert_equal nil, opt.arg_to_value("debug=1")
  end
  
  def test_help_usage
    opt = Miniparse::FlagOption.new spec:"--debug LEVEL" 
    assert opt.help_usage.include? "--debug LEVEL" 
  end
  
end
