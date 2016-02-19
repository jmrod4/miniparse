require 'test_helper'

include Miniparse

class InterfaceTest < Minitest::Test

  def test_utils
    s = "--option VALUE"
    assert_equal "--option", Interface.get_prefix(s)
    assert_equal "option",   Interface.get_name(s)
    s = "--option"
    assert_equal "--option", Interface.get_prefix(s)
    assert_equal "option",   Interface.get_name(s)
    s = "command"
    assert_equal "command", Interface.get_prefix(s)
    assert_equal "command", Interface.get_name(s)
  end

end


class OptionTest < Minitest::Test
 
  def test_simple_methods
    o = Option.new "--option VALUE"
    assert_equal :option, o.name
    assert_equal "--option", o.prefix
  end

end


class OptionSwitchTest < Minitest::Test
  
  def test_simple_methods
    o = OptionSwitch.new "--option"
    assert_equal :option, o.name
    assert_equal "--option", o.prefix
  
    name, val = OptionSwitch.format_to_name_value "--option"
    assert_equal true, val

    name, val = OptionSwitch.format_to_name_value "--no-option"
    assert_equal false, val

    assert_equal true, OptionSwitch.valid_format("--option")
    assert_equal true, OptionSwitch.valid_format("--no-option")
    assert_equal false, OptionSwitch.valid_format("option")
    assert_equal false, OptionSwitch.valid_format("-option")
    assert_equal false, OptionSwitch.valid_format("--option VALUE")
 end

  def test_value
    o = OptionSwitch.new "--option"
    assert_equal true, o.set_value("--option")
    assert_equal false, o.set_value("--no-option")

    assert_raises(RuntimeError) { o.set_value("--other") }
    assert_raises(RuntimeError) { o.set_value("other") }
  end

  def test_run
    o = OptionSwitch.new "--option"
    o.run

    a = 8
    o = OptionSwitch.new("--option") { a = a / 2 }
    o.run
    assert_equal 4, a

    a = 8
    o = OptionSwitch.new("--option") { |val| a = val }
    o.run
    assert_equal nil, a
  
    a = 8
    o = OptionSwitch.new("--option", "", true) { |val| a = val }
    o.run
    assert_equal true, a
  end

  def test_parse
    o = OptionSwitch.new "--option"
    assert_equal nil, o.parse("--other")
    assert_equal true, o.parse("--option")
    assert_equal false, o.parse("--no-option")
    assert_equal true, o.parse("--option")
  end
end


class OptionFlagTest < Minitest::Test
  
  def test_simple_methods
    o = OptionFlag.new "--option"
    assert_equal :option, o.name
    assert_equal "--option", o.prefix
  
    assert_equal false, OptionFlag.valid_format("--option")
    assert_equal false, OptionFlag.valid_format("--no-option")
    assert_equal false, OptionFlag.valid_format("option")
    assert_equal false, OptionFlag.valid_format("-option")
    assert_equal true, OptionFlag.valid_format("--option VALUE")

  end

  def test_value
    o = OptionFlag.new "--option"
    assert_equal "VALUE", o.set_value("--option VALUE")
    assert_equal "1", o.set_value("--option=1")
    
    assert_raises(RuntimeError) { o.set_value("--option") }
  end

  def test_parse
    o = OptionFlag.new "--option FILE"
    assert_equal nil, o.parse("--other")
    assert_raises(RuntimeError) { o.parse("--option") }
    #assert_raises(RuntimeError) { o.parse("--no-option") }
    assert_equal "1", o.parse("--option 1")
    assert_equal "file.txt", o.parse("--option file.txt")
  end

end
