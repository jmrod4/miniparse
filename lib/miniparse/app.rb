require 'miniparse'
require 'logger'

# this module is optional and it isn't required to use Miniparse, 
# you have to require it specifically with
#
#     require "miniparse/app"
#
# it allows an easy integration of parsing and output (and logging if desired)
# in your application
# 
# ## Simple example of use:
#
#     require "miniparse/app"
#    
#     Miniparse.set_control(
#         autoshortable: true,
#         )
#     App.configure_parser do |parser|
#       parser.add_program_description "my program does something\n"
#       parser.add_option("--list", "list something")
#       parser.parse ARGV
#     end
#    
#     # to see App.debug you have to specify the --debug option
#     # for example: 'ruby ex08_app_simple.rb --debug' 
#     App.debug App.options   # to stdout
#     App.info App.options    # to stdout
#     App.warn App.options    # to stderr
#     App.error App.options   # to stderr (note: it doesn't exit)
#    
#     # you have direct access to the parser object
#     puts "parser object: #{App.parser}"
#    
#     puts 'Done.'
#
# ## Example of how to setup a logger and logger level
#
#     App.logger = Logger.new('my.log') 
#     App.logger.level = Logger::DEBUG
#
#     ...
#
#
module App

  # error exit codes
  ERR_NOT_FOUND = 3
  ERR_IO = 4

  class NullLogger < Logger
    def initialize(*args); end
    def add(*args, &block); end
  end
  @logger = NullLogger.new       # no logging by default
  class << self
    # by default a null logger is set so no logging is done, to set a logger use for example `App.logger = Logger.new('my.log')` 
    attr_accessor :logger
  end
  
  # @param level (symbol) :file for file and method details, :method for only method details, :none for none
  # @return (string) the caller's caller info
  def self._from(level)
    caller[1] =~/([^\/]+):(.+):in `(.+)'/
    file = $1
    line = $2
    method = $3
    if level == :file
      "#{file}:#{line}:#{method}:"
    elsif level == :method
      "#{method}:"
    end
  end

  # The methods .debug, .info, .warn, .error and .fatal, output a message to
  # the appropiate IO stream. 
  # They also log to `@logger` if it was defined with `App.logger=`
  #
  # @param msg (string) is the message to output
  # @return (void)
  def self.debug(msg)
    logger.debug(_from(:method).chop) { msg }
    $stdout.puts "debug:#{_from(:method)} #{msg}"   if options[:debug]
  end

  def self.info(msg)
    logger.info msg 
    $stdout.puts "#{msg}"
  end

  def self.warn(msg)
    logger.warn(_from(:method).chop) { msg }
    $stderr.puts "warning:#{_from(:file)} #{msg}"
  end

  def self.error(msg)
    logger.error(_from(:method).chop) { msg }
    $stderr.puts "error:#{_from(:file)} #{msg}"
  end

  def self.fatal(msg)
    logger.fatal(_from(:file).chop) { msg }
    $stderr.puts "fatal error:#{_from(:file)} #{msg}"
  end

  
  # @return (hash) parsed options, i.e. specified in argv
  def self.options
    parser.options  
  end
  
  # defines a block that takes parser as parameter and configures and parses it
  #
  # @return (void) specified block
  def self.configure_parser(&block)
    reset_parser
    @do_configure_parser = block    
  end
  
  @parser = nil
  @do_configure_parser = lambda { |parser| parser.parse ARGV }

  # (the first time it is called after .configure_parser, it does a lazy 
  # parser creation using the block defined in .configure_parser)  
  #
  # @return (Parser) parser 
  def self.parser
    return @parser   if @parser
    @parser = Miniparse::Parser.new
    parser.add_option("--debug", nil, negatable: false)
    @do_configure_parser.call(parser)
    parser
  end     
    
  # re-initializes the parser to the last configuration 
  # 
  # @return (void)
  def self.reset_parser
    @parser = nil
  end

end
