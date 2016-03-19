require 'miniparse'

module App
 
  # error exit codes
  ERR_NOT_FOUND = 3
  ERR_IO = 4

  @parser = nil
  @do_configure_parser = lambda { |parser| parser.parse ARGV }
  
  def self.error(msg)
    $stderr.puts "error: #{msg}"  
  end
  
  def self.warn(msg)
    $stderr.puts "warning: #{msg}"  
  end
  
  def self.info(msg)
    $stdout.puts "info: #{msg}"  
  end
  
  def self.debug(msg)
    $stdout.puts "debug: #{msg}"    if App.options[:debug]
  end
  
  def self.options
    parser.options  
  end

  def self.configure_parser(&block)
    reset_parser
    @do_configure_parser = block
    nil    
  end
  
  # lazy parser creation  
  def self.parser
    return @parser   if @parser
    @parser = Miniparse::Parser.new
    parser.add_option("--debug", nil, negatable: false)
    @do_configure_parser.call(parser)
    parser
  end     
    
  # re-initialize the parser (but doesn't affect the configuration)
  def self.reset_parser
    @parser = nil
  end

end
