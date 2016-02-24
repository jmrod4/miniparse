require 'test_helper'


class TestOptionsParse < Minitest::Test

  def setup
    @parser = Miniparse::Parser.new
    @parser.add_option "--debug", "activate debug"
    @parser.add_option "--verbose LEVEL"
  end

  def test_no_arguments 
    assert_raises(ArgumentError, 
      "FEATURE parser doesn't default to ARGV"
      ) { args =  @parser.parse }
  end
  
  def test_nothing
    assert_equal([],    @parser.parse([]), 
      "if nothing to do, do nothing 1")
    assert_equal([""],  @parser.parse([""]), 
      "if nothing to do, do nothing 2")
    assert_equal([" "], @parser.parse([" "]), 
      "if nothing to do, do nothing 3")
    assert_equal([],    @parser.parse(""), 
      "if nothing to do, do nothing 4")
  end
  
  def test_bad_arg
    assert_raises(NoMethodError, 
      "FEATURE parser doesn't implicitly convert string, for trivial conversions like .split let the user do it"
      ) { @parser.parse "a b c" }
      
    assert_raises(ArgumentError) { @parser.parse ["--other"] }
    assert_raises(ArgumentError) { @parser.parse ["--"] }
    assert_raises(ArgumentError) { @parser.parse ["---"] }
    assert_raises(ArgumentError) { @parser.parse ["-o"] }
    assert_raises(ArgumentError) { @parser.parse ["-"] }
    assert_raises(ArgumentError) { @parser.parse ["--verbose"] }
    assert_raises(ArgumentError) { @parser.parse ["--verbose="] }

    assert_raises(ArgumentError) { @parser.parse ["-d"] }
    assert_raises(ArgumentError) { @parser.parse ["--deb"] }
  end
  
  def test_only_arguments
    argv = "a b c".split
    args = @parser.parse argv   
    assert_respond_to args, :each, "parse returns enumerable" 
 
    assert_equal argv, args 
    assert_equal args, @parser.args
        
    assert @parser.options.empty?
    refute @parser.current_command
    refute @parser.command_parsed
    # value of command_args not significant
    # refute @parser.command_args
    # value of command_options not significant
    # refute @parser.command_options
  end

  def test_switch
    @parser.parse []
    refute @parser.options[:debug]
    
    @parser.parse ["--debug"]
    refute @parser.options.empty?
    assert @parser.options[:debug]

    refute @parser.current_command
    refute @parser.command_parsed

    @parser.parse []
    refute @parser.options[:debug].nil?
  end
  
  def test_switch_negate
    @parser.parse ["--no-debug"]
    refute @parser.options.empty?
    refute @parser.options[:debug]
  end

  def test_flag
    @parser.parse []
    refute @parser.options[:verbose]
    
    @parser.parse ["--verbose", "1"]
    refute @parser.options.empty?
    assert_equal "1", @parser.options[:verbose]

    refute @parser.current_command
    refute @parser.command_parsed
    
    @parser.parse []
    refute @parser.options[:verbose].nil?
  end
  
  def test_flag_alternative_1
    @parser.parse ["--verbose 2"]
    refute @parser.options.empty?
    assert_equal "2", @parser.options[:verbose]
  end
  
  def test_flag_alternative_2
    @parser.parse ["--verbose=3"]
    refute @parser.options.empty?
    assert_equal "3", @parser.options[:verbose]
  end

end



class TestAddOption < Minitest::Test

end



class TestCommandParse < Minitest::Test

end



class TestAddCommand < Minitest::Test

end




