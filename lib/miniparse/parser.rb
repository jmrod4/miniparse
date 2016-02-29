module Miniparse

# TODO FEATURE enable command help <command> to get help on any command

class Parser

  # @return the command the next add_option will apply to
  attr_reader :current_command
  # @return after parsing (i.e. specified) rest of arguments 
  attr_reader :args, :command_args 
  # @return parsed (i.e. specified) command or nil if no command
  attr_reader :parsed_command

  attr_reader :_global_broker, :_commands, :_command_brokers 
  
  def initialize(opts = {})
    Miniparse.set_control opts
    
    @_global_broker = OptionBroker.new
    @_commands = {}
    @_command_brokers = {}
    @current_command = nil
    
    add_option("--help", nil, negatable:false) do
      puts help_text
      exit ERR_HELP_REQ
    end
  end

  # FIXME document arguments
  def add_option(spec, desc, opts={}, &block)
    _current_broker.add_option(spec, desc, opts, &block)
  end

  # FEATURE if a command already exists it gets overwritten (and its options lost)
  # FIXME document arguments
  def add_command(name, desc, opts={}, &block)
    if !Command.valid_spec(name)
      raise SyntaxError, "unknown or invalid command specification '#{name}'"
    end
    args = opts.merge(spec:name, desc:desc)
    cmd = Command.new(args, &block)
    @_commands[cmd.name] = cmd
    @_command_brokers[cmd.name] = OptionBroker.new
    @current_command = cmd.name
  end
    
  # @param argv is like ARGV but just for this parser
  # @return unprocessed arguments
  def parse(argv)
    try_argument do
      global_argv, command_arg, command_argv = _split_argv(argv)
      @args = _global_broker.parse_argv(global_argv)
      if command_arg
        @parsed_command = Command.spec_to_name(command_arg)
        @command_args = _command_brokers[parsed_command].parse_argv(command_argv)
        _commands[parsed_command].run
      end
      if (! Miniparse.control[:global_args]) && (! args.empty?)
        error = (_commands.empty?)? "extra arguments" : "unrecognized command"
        raise ArgumentError, "#{error} '#{args[0]}'"
      end
      args      
    end
  end

  # @return parsed (i.e. specified) global options
  def options
    _global_broker.parsed_options
  end

  # @return  parsed (i.e. specified) command options
  def command_options
    _command_brokers[parsed_command].parsed_options    if parsed_command
  end
  
  def help_text
    text = help_usage + "\nOptions:\n" + _help_global_options
    if !_commands.empty?
      nodesc = []
      help_desc = _commands.keys.sort.collect do |key| 
         help = _commands[key].help_desc 
         nodesc << _commands[key].name    unless help
         help
      end
      text_desc = help_desc.compact.join("\n")
      text_nodesc = nodesc.join(", ")
      if text_desc.size > 0
        text += "\nCommands:\n"
        text += text_desc 
      end
      if text_nodesc.size > 0
        text += "\nMore commands: \n"
        text += ' '*Miniparse.control[:width_indent]
        text += text_nodesc
      end
    end
    text
  end

  def help_usage
    if Miniparse.control[:detailed_usage]
      right_text = @_global_broker.help_usage
    elsif _commands.empty?
      right_text = "[options]"
    else
      right_text = "[global_options]"   
    end
    if !_commands.empty?
      right_text += " <command> [command_options]"
    end
    right_text += " <args>"
    left_text = "usage: #{File.basename($PROGRAM_NAME)}"
    
    if Miniparse.control[:formatted_help]
      width_display = Miniparse.control[:width_display]
      width_left = left_text.size
      Miniparse.two_cols_word_wrap(left_text, ' ', right_text, 
          width_left, width_display - 1 - width_left)
    else
      left_text + " " + right_text
    end
  end

  def _current_broker
    if current_command
      _command_brokers[current_command]
    else
      _global_broker
    end
  end

  def try_argument
    begin
      yield
    rescue ArgumentError => e
      raise    unless Miniparse.control[:catch_argument_error]
      prg = File.basename($PROGRAM_NAME)
      $stderr.puts "#{prg}: error: #{e.message}"
      $stderr.puts help_usage
      # (#{e.backtrace[-1]})")
      exit ERR_ARGUMENT
    end
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

  def _help_global_options
    @_global_broker.help_desc
  end

end



end
