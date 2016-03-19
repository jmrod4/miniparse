module Miniparse

# TODO create external documentation, maybe auto


class Parser

  # @return after parsing (i.e. specified) rest of arguments 
  attr_reader :args
  
  # @return parsed (i.e. specified) global options
  def options; global_broker.parsed_values; end
  
  # @return  parsed (i.e. specified) command (nil if none), options and arguments
  def command; commander.parsed_command; end
  def command_options; commander.parsed_values; end
  def command_args; commander.parsed_args; end
  
  # @return the command the next add_option will apply to
  def current_command; commander.current_command; end

  
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
  
  
  def add_program_description(desc)
    @program_desc = desc
  end
  
  
  # @param spec is the option specification, similar to the option invocation 
  # in the command line (ex. "--debug" or "--verbose LEVEL")
  #
  # @param desc is a short description of the option
  # 
  # @param opts are the options to apply to the option
  # :default
  # :negatable (used only for switches)
  # :shortable
  def add_option(spec, desc, opts={}, &block)
    args = opts.merge(spec: spec, desc: desc)
    current_broker.add_option(args, &block)
  end

  # @param name is the command name (ex. either "kill" or :kill)
  #
  # @param desc is a short description of the command
  # 
  # @param opts are the options to apply to the command
  # :no_options  indicates the command has no command line options
  def add_command(name, desc, opts={}, &block)
    args = opts.merge(spec: name, desc: desc)
    commander.add_command(args, &block)
  end

  # @param argv is like ARGV but just for this parser
  # @return unprocessed arguments
  def parse(argv)
    if Miniparse.control(:help_cmdline_empty) && argv.empty?
      puts help_usage
      exit ERR_HELP_REQ  
    end
    try_argument do
      global_argv, cmd_name, cmd_argv = commander.split_argv(argv)
      @args = global_broker.parse_argv(global_argv)
      if cmd_name
        commander.parse_argv(cmd_name, cmd_argv)
      end
      if Miniparse.control(:raise_global_args) && (! args.empty?)
        # FIXME review this logic later
        error = current_command  ?  "unrecognized command"  :  "extra arguments"
        raise ArgumentError, "#{error} '#{args[0]}'"
      end
      args      
    end
  end

  # @return a help message with the short descriptions
  def help_desc
    #FIXME
    text = ""
    if (global = global_broker.help_desc).size > 0
      text += "\nOptions:\n"
      text += global
    end
    text += commander.help_desc   
    text
  end

  # @return a usage message
  def help_usage
    #FIXME
    if Miniparse.control(:detailed_usage)
      right_text = @global_broker.help_usage
    elsif current_command
      right_text = "[global_options]"   
    else
      right_text = "[options]"
    end
    if current_command
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

  def try_argument
    #FIXME
    begin
      yield
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



end
