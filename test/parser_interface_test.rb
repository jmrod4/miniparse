require 'test_helper'



class TestParserInterface < Minitest::Test
  
  def setup
    @object = Miniparse::Parser.new
  end
  
  def test_parser_respond
    assert_respond_to @object, :add_option
    assert_respond_to @object, :parse
    assert_respond_to @object, :args
    assert_respond_to @object, :options
    assert_respond_to @object, :add_command
    assert_respond_to @object, :current_command
    assert_respond_to @object, :parsed_command
    assert_respond_to @object, :command_args
    assert_respond_to @object, :command_options
    assert_respond_to @object, :help_text
  end
  
end

