require 'test_helper'



class TestCommandArgs < Minitest::Test
  # FIXME
end



class TestCommandOptions < Minitest::Test
  # FIXME
end



class TestParse < Minitest::Test

  def setup
    @parser = Miniparse::Parser.new
    @parser.add_option "--debug", "activate debug"
    @parser.add_option "--verbose LEVEL", nil
  end

  def test_no_arguments 
    assert_raises(ArgumentError, 
        "FEATURE parser doesn't default to ARGV"
        ) { @parser.parse }
  end
  
  def test_nothing
    assert_equal([],    @parser.parse([]), 
      "if nothing to do, do nothing 1")
    assert_equal([""],  @parser.parse([""]), 
      "if nothing to do, do nothing 2")
    assert_equal([" "], @parser.parse([" "]), 
      "if nothing to do, do nothing 3")
    
    #assert_equal([],    @parser.parse(""), 
    #  "not significative either result")
  end

  def test_bad_arg
    assert_raises(NoMethodError, 
        "FEATURE parser doesn't implicitly convert string, for trivial conversions like 'a b c'.split let the user do it"
        ) { @parser.parse "a b c" }
  end  
  
  def test_only_arguments
    argv = "a b c".split
    @parser.parse argv
    args = @parser.args    
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

end



class TestOptionsParse < Minitest::Test

  def setup
    @parser = Miniparse::Parser.new
    @parser.add_option "--debug", "activate debug"
    @parser.add_option "--verbose LEVEL", nil
  end

  def test_bad_arg
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

  def setup
    @parser = Miniparse::Parser.new
  end

  def test_nodesc
    assert_raises(ArgumentError) { @parser.add_option("--debug") }
  end
  
  def test_block
    k = 2
    @parser.add_option("--debug", nil) { k = 6 }
    assert_equal 2, k
    @parser.parse ["--debug"]
    assert_equal 6, k
  end  

  def test_negatable
    @parser.add_option("--debug", nil, negatable:true)
    @parser.parse ["--no-debug"]
    assert_equal false, @parser.options[:debug]
  end

  def test_not_negatable
    @parser.add_option("--debug", nil, negatable:false)
    assert_raises(ArgumentError) { @parser.parse ["--no-debug"] }
  end
  
  def test_duplicate_option
    @parser.add_option("--debug", nil, negatable:true)
    @parser.parse ["--no-debug"]
    # FIXME not sane behaviour: the second one gets added but when parsing it uses the first found and not the last added
    @parser.add_option("--debug", nil, negatable:false)
    # assert_raises(ArgumentError) { @parser.parse ["--no-debug"] }
    @parser.parse ["--no-debug"]
  end
  
end



class TestCommandParse < Minitest::Test

  def setup
    @parser = Miniparse::Parser.new
  end

  def test_bad_arg
    k = 1
    @parser.add_command("list", nil) { k = 2 }
    k = 3
    @parser.parse ["other"]
    assert_equal "other", @parser.args[0]
    @parser.parse ["lis"]
    assert_equal "lis", @parser.args[0]
    @parser.parse ["list other"]
    assert_equal "list other", @parser.args[0]
    assert_equal 3, k
  end
  
  def test_normal
    k = 1
    @parser.add_command("list", nil) { k = 2 }
    k = 3
    @parser.parse ["list"]
    assert_equal nil, @parser.args[0]
    assert_equal 2, k    
  end

end



class TestAddCommand < Minitest::Test

  def setup
    @parser = Miniparse::Parser.new
  end

  def test_nodesc
    assert_raises(ArgumentError) { @parser.add_command("list") }
  end

  def test_block
    k = 2
    @parser.add_command("list", nil) { k = 6 }
    assert_equal 2, k
    @parser.parse ["list"]
    assert_equal 6, k
  end  
  
  def test_duplicate_command
    k = 1
    @parser.add_command("list", nil) { k = 2 }
    k = 3
    @parser.parse ["list"]
    assert_equal 2, k    
    @parser.add_command("list", nil) { k = 4 }
    @parser.parse ["list"]
    assert_equal 4, k    
   end
  
end



class TestHelpMsg < Minitest::Test

  def setup
    @parser = Miniparse::Parser.new
    @parser.add_option "--debug", "activate debug"
    @parser.add_option "--verbose LEVEL", nil
  end

  def test_negatable
    @parser.add_option("--sort", nil, negatable:true)
    assert @parser.help_msg =~ /\[--\[no-\]sort\]/ 
  end
  
  def test_not_negatable
    @parser.add_option("--sort", nil, negatable:false)
    assert @parser.help_msg =~ /\[--sort\]/ 
  end

  def test_desc
    help = @parser.help_msg
    assert help =~ /\s+--debug\s+/
    assert help =~ /activate debug/
    refute help =~ /\s+--verbose\s+/
  end
  
  def test_flag_msg
    assert @parser.help_msg =~ /\[--verbose LEVEL\]/ 
  end
  
end



