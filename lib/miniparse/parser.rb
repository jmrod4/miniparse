module Miniparse


# error exit codes
ERR_HELP_REQ = 1
  
# behaviour controlers
Error_on_unrecognized_option = true


class Parser

  # @return the command the next add_option will apply to
  attr_reader :current_command
  # @return after parsing (i.e. specified) rest of arguments 
  attr_reader :args, :command_args 
  # @return parsed (i.e. specified) command or nil if no command
  attr_reader :command_parsed

  attr_reader :_global_broker, :_commands, :_command_brokers 
  
  def initialize
    @_global_broker = OptionBroker.new
    @_commands = {}
    @_command_brokers = {}
    @current_command = nil
    
    add_option("--help", nil, negate:false) do
      puts _help_usage
      puts
      puts _help_global_options
      exit ERR_HELP_REQ
    end
  end

  def _current_broker
    if current_command
      _command_brokers[current_command]
    else
      _global_broker
    end
  end

  def add_option(spec, desc, opts={}, &block)
    _current_broker.add_option(spec, desc, opts, &block)
  end

  def add_command(name, opts={}, &block)
    args = opts.merge(spec:name)
    cmd = Command.new(args, &block)
    @_commands[cmd.name] = cmd
    @_command_brokers[cmd.name] = OptionBroker.new
    @current_command = cmd.name
  end
    
  # @param argv is like ARGV
  # @return index number of the first found command, nil if not found
  def _index_command(argv)
    _commands.values.each do |cmd|
      index = argv.find_index do |arg|
        cmd.check(arg)
      end
      return index if    index
    end
    nil
  end

  # @param argv is like ARGV but just for this parser
  # @return unprocessed arguments
  def parse(argv)
    global_argv, command_arg, command_argv = _split_argv(argv)
    @args = _global_broker.parse_argv(global_argv)
    if command_arg
      @command_parsed = Command.spec_to_name(command_arg)
      @command_args = _command_brokers[command_parsed].parse_argv(command_argv)
      _commands[command_parsed].run
    end
    args
  end

  # @return parsed (i.e. specified) global options
  def options
    _global_broker.parsed_options
  end

  # @return  parsed (i.e. specified) command options
  def command_options
    _command_brokers[command_parsed].parsed_options    if command_parsed
  end

  # @param argv is like ARGV
  # @return an array of argv parts: [global_argv, command_arg, command_argv] 
  def _split_argv(argv)
    index = _index_command(argv)
    if index
      global_argv = (index == 0)? [] : argv[0..index-1]
      command_argv = argv[index+1..-1]
      [global_argv, argv[index], command_argv]
    else  
      [argv, nil, []]
    end
  end

  def _help_usage(detailed:true)
    global = (detailed)? @_global_broker.help_usage : "[global_options]"
    "usage: #{$PROGRAM_NAME} #{global} [<command> [command_options]]"
  end

  def _help_global_options
    @_global_broker.help_desc
  end

end


end
