require 'miniparse'

# this optional module allows an easy integration of parsing and trivial output,
# in your application
# 
# an example of use:
#
#    require "miniparse/app"
#    
#    App.configure_parser do |parser|
#      Miniparse.set_control(
#          autoshortable: true,
#          )
#      parser.add_program_description "my program help introduction\n"
#      parser.add_option("--list", "list something")
#      parser.parse ARGV
#    end
#    
#    # to see App.debug you have to specify the --debug option
#    # for example: 'ruby ex08_app_simple.rb --debug' 
#    App.debug App.options   # to stdout
#    App.info App.options    # to stdout
#    App.warn App.options    # to stderr
#    App.error App.options   # to stderr (note: it doesn't exit)
#    
#    # you have direct access to the parser object
#    puts "parser object: #{App.parser}"
#    
#    puts 'Done.'
#
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
