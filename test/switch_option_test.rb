require 'test_helper'


class TestSwitchInterface < Minitest::Test

  include ElementInterface
  include ElementRequeriments
  include OptionInterface
  include OptionRequeriments

  def setup
    @object = Miniparse::SwitchOption.new spec:"--some"
  end

end



class TestSwitchOption < Minitest::Test
  def test_class_methods
    assert_equal :list, Miniparse::SwitchOption.spec_to_name("--list")
    assert_nil Miniparse::SwitchOption.spec_to_name(" --list")
    assert_nil Miniparse::SwitchOption.spec_to_name("--list ")
    assert_nil Miniparse::SwitchOption.spec_to_name("-list")
    assert_nil Miniparse::SwitchOption.spec_to_name("-l")
  end

  def test_arg_to_value
    opt = Miniparse::SwitchOption.new spec: "--debug", negatable: true 
    assert_equal true, opt.arg_to_value("--debug")
    assert_equal false, opt.arg_to_value("--no-debug")
    assert_equal nil, opt.arg_to_value("debug")
    opt = Miniparse::SwitchOption.new spec:"--debug", negatable: false
    assert_equal true, opt.arg_to_value("--debug")
    assert_equal nil, opt.arg_to_value("--no-debug")
    assert_equal nil, opt.arg_to_value("debug")
  end

  def test_check
    opt = Miniparse::SwitchOption.new spec: "--debug", 
          negatable: true, shortable: false
    assert opt.check "--debug"
    assert opt.check "--no-debug"
    refute opt.check "--DEBUG"
    refute opt.check "--debu"
    refute opt.check "-debug"
    refute opt.check "debug"
    refute opt.check "-d"
    opt = Miniparse::SwitchOption.new spec: "--debug", negatable: false
    assert opt.check "--debug"
    refute opt.check "--no-debug"
  end
  
  def test_check_shortable
    opt = Miniparse::SwitchOption.new spec: "--debug", 
          negatable: true, shortable: true
    assert opt.check "-d"
  end
  
  def test_help_usage
    opt = Miniparse::SwitchOption.new spec: "--debug", negatable: true 
    refute opt.help_usage.include? "--debug" 
    assert opt.help_usage.include? "--[no-]debug" 
    opt = Miniparse::SwitchOption.new spec: "--debug", negatable: false
    assert opt.help_usage.include? "--debug" 
    refute opt.help_usage.include? "--[no-]debug" 
  end

  def test_help_desc
    opt = Miniparse::SwitchOption.new(spec: "--debug", 
        desc: "some", default: true)
    assert opt.help_desc =~ /default/
    opt = Miniparse::SwitchOption.new(spec: "--debug", 
        desc: "some", default: false)
    refute opt.help_desc =~ /default/
  end
end

