

class TestParseSwitch 

  def setup
    @parser = Miniparse::Parser.new
    @parser.add "--debug", "activate debug"
  end

  def test_bad_switch
    assert_raises(RuntimeError) { @parser.parse ["--other"] }
    assert_raises(RuntimeError) { @parser.parse ["--debu g"] }
    assert_raises(RuntimeError) { @parser.parse ["--deb"] }
    assert_raises(RuntimeError) { @parser.parse ["--"] }
    assert_raises(RuntimeError) { @parser.parse ["---"] }
    assert_raises(RuntimeError) { @parser.parse ["--debug="] }
    assert_raises(RuntimeError) { @parser.parse ["--debug=1"] }
    assert_raises(RuntimeError) { @parser.parse ["--debug "] }
    assert_raises(RuntimeError) { @parser.parse ["--debug 1"] }
    
    assert_includes(@parser.parse(["-debug"]), "-debug",
      "TODO consider to include this as a managed error")
    
    assert_includes(@parser.parse(["-d"]), "-d",
      "TODO consider to include auto single character options for switchs")
  end


  def test_default_value_nil
    parser = Miniparse::Parser.new
    parser.add "--debug", "activate debug"
    arg = parser.parse ["a"]
    
    assert_nil parser.options[:debug] 
    
    assert_empty parser.options,
      "FEATURE don't add an option if default value is nil"
  end


  def test_good_switch
    arg = @parser.parse ["--debug"]
    assert(@parser.options[:debug] == true)

    arg = @parser.parse ["--no-debug"]
    assert(@parser.options[:debug] == false)

    assert_empty @parser.parse ["--debug"]
    assert_empty @parser.parse ["--no-debug"]
  end

end


class TestParseFlag 
  
  def setup
    @parser = Miniparse::Parser.new
    @parser.add "--verbose LEVEL"
  end


  def test_retest
  end


  def test_bad_switch
    assert_raises(RuntimeError) { @parser.parse ["--other"] }
    assert_raises(RuntimeError) { @parser.parse ["--verbo se"] }
    assert_raises(RuntimeError) { @parser.parse ["--verb"] }
    assert_raises(RuntimeError) { @parser.parse ["--"] }
    assert_raises(RuntimeError) { @parser.parse ["---"] }
    assert_raises(RuntimeError) { @parser.parse ["--verbose="] }
    assert_raises(RuntimeError) { @parser.parse ["--verbose "] }
    assert_raises(RuntimeError) { @parser.parse ["--no-verbose"] }
    
    assert_includes(@parser.parse(["-verbose"]), "-verbose",
      "TODO consider to include this as a managed error")
    
    assert_includes(@parser.parse(["-v=1"]), "-v=1",
      "TODO consider not to include auto single character options for flags")
  end


  def test_default_value_nil
    parser = Miniparse::Parser.new
    parser.add "--verbose LEVEL"
    parser.parse ["a"]
    
    assert_nil parser.options[:verbose] 
    
    assert_empty parser.options,
      "FEATURE don't add an option if default value is nil"
  end


  def test_good_switch
    assert_empty @parser.parse ["--verbose=1"]
    assert_empty @parser.parse ["--verbose 1"]

    @parser.parse ["--verbose 1"]
    assert_equal "1", @parser.options[:verbose]

    @parser.parse ["--verbose=1"]
    assert_equal "1", @parser.options[:verbose]
  end
end
