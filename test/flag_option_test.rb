require 'test_helper'



class TestFlagInterface < Minitest::Test

  include ElementInterface
  include ElementRequeriments
  include OptionInterface
  include OptionRequeriments

  def setup
    @object = Miniparse::FlagOption.new spec: "--some SOME"
  end

end



class TestFlagOption < Minitest::Test

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
    opt = Miniparse::FlagOption.new spec: "--debug LEVEL"
    assert_equal "1", opt.arg_to_value("--debug 1")
    assert_equal "1", opt.arg_to_value("--debug=1")
    assert_equal nil, opt.arg_to_value("--debug")
    assert_equal nil, opt.arg_to_value("--debug=")
    assert_equal nil, opt.arg_to_value("--debug ")
    assert_equal " ", opt.arg_to_value("--debug  ")
    assert_equal nil, opt.arg_to_value("debug=1")
  end
  
  def test_help_usage
    opt = Miniparse::FlagOption.new spec: "--debug LEVEL" 
    assert opt.help_usage.include? "--debug LEVEL" 
  end
 
  def test_help_desc
    opt = Miniparse::FlagOption.new(spec: "--debug LEVEL", 
        desc: "some", default: "other")
    assert opt.help_desc =~ /some.+other/
  end
  
end