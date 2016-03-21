module Miniparse

# TODO create external documentation, maybe auto


# this is the key class to the miniparse library, 
# please find below an example of use:
#
#     require 'miniparse'
#    
#     parser = Miniparse::Parser.new
#     parser.add_option "--debug", "activate debugging"
#     parser.parse ARGV
#    
#     if parser.options[:debug]
#       puts "DEBUG ACTIVATED!"
#     else
#       puts "run silently"
#     end
#
class Parser

  # @return [array] rest of arguments after parsing 
  attr_reader :args
  
  # @return [hash] parsed, i.e. specified, global options
  def options; global_broker.parsed_values; end
  
  # @return [symbol|nil] name of command parsed , i.e. specified, (or nil if none)
  def command_name; commander.parsed_command_name; end

  # @return [hash] parsed option values for the parsed command
  def command_options; commander.parsed_values; end
  
  # @return [array] remaining command args after parsing the options for the parsed command 
  def command_args; commander.parsed_args; end
  
  # @return [symbol] the name of the command the next #add_option will apply to
  def current_command_name; commander.current_command_name; end

  def initialize
    @commander = Commander.new
    @program_desc = nil     
    @global_broker = OptionBroker.new do
      print program_desc + "\n"    if program_desc
      print help_usage + "\n"
      print help_desc + "\n"
      exit ERR_HELP_REQ
    end
  end
 
  # @param desc [string] is the program description to display on help msgs
  # @return [void] same argument  
  def add_program_description(desc)
    @program_desc = desc
  end
  
  # @param spec [string] is the option specification, similar to the option
  #   invocation in the command line (e.g. `--debug` or `--verbose LEVEL`)
  # @param desc [string|nil] is a short description of the option
  # @param opts [hash] are the options to apply to the option, keys can include:
  #
  #   * :default
  #   * :negatable (used only for switches)
  #   * :shortable
  #
  # @return [void] added Option
  def add_option(spec, desc, opts={}, &block)
    args = opts.merge(spec: spec, desc: desc)
    current_broker.add_option(args, &block)
  end

  # @param name [symbol|string] is the command name
  # @param desc [string|nil] is a short description of the command
  # @param opts [hash] are the options to apply to the command, keys can be:
  #
  #   * :no_options  indicates the command has no command line options
  #
  # @return [void] added Command
  def add_command(name, desc, opts={}, &block)
    args = opts.merge(spec: name, desc: desc)
    commander.add_command(args, &block)
  end

  # @param argv is like ARGV but just for this parser
  # @return [array] unprocessed arguments
  def parse(argv)
    if Miniparse.control(:help_cmdline_empty) && argv.empty?
      puts help_usage
      exit ERR_HELP_REQ  
    end
    try_argument do
      global_argv, cmd_name, cmd_argv = commander.split_argv(argv)
      @args = global_broker.parse_argv(global_argv)
      
      commander.parse_argv(cmd_name, cmd_argv)    if cmd.name
      if Miniparse.control(:raise_global_args) && !args.empty?
        error = current_command_name  ?  "unrecognized command"  :  "extra arguments"
        raise ArgumentError, "#{error} '#{args[0]}'"
      end
      args      
    end
  end

  # @return [string] a help message with the short descriptions
  def help_desc
    text = ""
    if (global = global_broker.help_desc).size > 0
      text += "\nOptions:\n"
      text += global
    end
    text += commander.help_desc   
    text
  end

  # @return [string] a usage message
  def help_usage
    if Miniparse.control(:detailed_usage)
      right_text = @global_broker.help_usage
    elsif current_command_name
      right_text = "[global_options]"   
    else
      right_text = "[options]"
    end

    if current_command_name
      right_text += " <command> [command_options]"
    end
    right_text += " <args>"

    Miniparse.help_usage_format(right_text)
  end

protected

  attr_reader :commander, :global_broker, :program_desc

  def current_broker
    commander.current_broker || global_broker
  end

  def try_argument(&block)
    block.call
  rescue ArgumentError => except
    raise    unless Miniparse.control(:rescue_argument_error)
    prg = File.basename($PROGRAM_NAME)
    $stderr.puts "#{prg}: error: #{except.message}"
    $stderr.puts
    $stderr.puts help_usage
    # (#{except.backtrace[-1]})")
    exit ERR_ARGUMENT
  end
    
end



end
