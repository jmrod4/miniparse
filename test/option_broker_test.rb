require 'test_helper'


class TestOptBrokerInterface < Minitest::Test
  
  def setup
    @object = Miniparse::OptionBroker.new
  end
  
  def test_opt_broker_accessors
    assert_respond_to @object, :parsed_values
  end

  def test_opt_broker_methods
    assert_respond_to @object, :add_option
    assert_respond_to @object, :parse_argv
    assert_respond_to @object, :help_usage
    assert_respond_to @object, :help_desc
  end

end


class TestOptBroker < Minitest::Test
  # FIXME add tests for OptionBroker
end