module Miniparse

# TODO create external documentation, maybe auto

# TODO this class maybe does too much, separate a command broker or something similar

class Parser

  # @return the command the next add_option will apply to
  attr_reader :current_command
  # @return after parsing (i.e. specified) rest of arguments 
  attr_reader :args, :command_args 
  # @return parsed (i.e. specified) command or nil if no command
  attr_reader :parsed_command

  def initialize
    @global_broker = OptionBroker.new
    @commands = {}
    @command_brokers = {}
    @current_command = nil
    
    add_option("--help", nil, negatable: false) do
      puts help_usage
      puts help_desc
      exit ERR_HELP_REQ
    end
    
  end

  # @param spec is the option specification, similar to the option invocation 
  # in the command line (ex. "--debug" or "--verbose LEVEL")
  #
  # @param desc is a short description of the option
  # 
  # @param opts are the options to apply to the option
  # :negatable (for switches)
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
    if !Command.valid_spec(name)
      raise SyntaxError, "unknown or invalid command specification '#{name}'"
    end
    # only run before first command get added
    add_help_command    if name != :help && commands.empty?
    args = opts.merge(spec: name, desc: desc)
    cmd = Command.new(args, &block)
    # FEATURE if a command already exists it gets overwritten (and its options lost)
    @commands[cmd.name] = cmd
    @command_brokers[cmd.name] = OptionBroker.new
    @current_command = cmd.name    unless opts[:no_options]
    cmd
  end
    
  # @param argv is like ARGV but just for this parser
  # @return unprocessed arguments
  def parse(argv)
    if Miniparse.control(:help_cmdline_empty) && argv.empty?
      puts help_usage
      exit ERR_HELP_REQ  
    end
    try_argument do
      global_argv, command_arg, command_argv = split_argv(argv)
      @args = global_broker.parse_argv(global_argv)
      if command_arg
        @parsed_command = Command.spec_to_name(command_arg)
        @command_args = command_brokers[parsed_command].parse_argv(command_argv)
        commands[parsed_command].run 
      end
      if Miniparse.control(:raise_global_args) && (! args.empty?)
        error = (commands.empty?)? "extra arguments" : "unrecognized command"
        raise ArgumentError, "#{error} '#{args[0]}'"
      end
      args      
    end
  end

  # @return parsed (i.e. specified) global options
  def options
    global_broker.parsed_values
  end

  # @return  parsed (i.e. specified) command options
  def command_options
    command_brokers[parsed_command].parsed_values    if parsed_command
  end
  
  # @return a help message with the short descriptions
  def help_desc
    text = ""
    if global_broker.help_desc.size > 0
      text += "\nOptions:\n" + global_broker.help_desc
    end
    unless commands.empty?
      nodesc = []
      help_desc = commands.keys.sort.collect do |key| 
         help = commands[key].help_desc 
         nodesc << commands[key].name    unless help
         help
      end
      text_desc = help_desc.compact.join("\n")
      unless text_desc.empty?
        text += "\nCommands:\n"
        text += text_desc 
      end
      text_nodesc = nodesc.join(", ")
      unless text_nodesc.empty?
        text += "\nMore commands: \n"
        text += ' '*Miniparse.control(:width_indent)
        text += text_nodesc
      end
    end
    text
  end

  # @return a usage message
  def help_usage
    if Miniparse.control(:detailed_usage)
      right_text = @global_broker.help_usage
    elsif commands.empty?
      right_text = "[options]"
    else
      right_text = "[global_options]"   
    end
    if !commands.empty?
      right_text += " <command> [command_options]"
    end
    right_text += " <args>"
    help_usage_format(right_text)
  end

protected

  attr_reader :global_broker, :commands, :command_brokers 
  
  def current_broker
    if current_command
      command_brokers[current_command]
    else
      global_broker
    end
  end

  def try_argument
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

  # @param argv is like ARGV
  # @return index number of the first found command, nil if not found
  def index_command(argv)
    commands.values.each do |cmd|
      index = argv.find_index  { |arg|  cmd.check(arg) }
      return index if    index
    end
    nil
  end

  # @param argv is like ARGV
  # @return an array of argv parts: [global_argv, command_arg, command_argv] 
  def split_argv(argv)
    index = index_command(argv)
    if index
      global_argv = (index == 0)? [] : argv[0..index-1]
      command_argv = argv[index+1..-1]
      [global_argv, argv[index], command_argv]
    else  
      [argv, nil, []]
    end
  end

  def add_help_command
    add_command(:help, nil, no_options: true) do
      index = index_command(command_args)
      if index
        cmd = command_args[index].to_sym
        header = "Command #{cmd}:  #{commands[cmd].desc}"
        text = "\n"
        text += Miniparse.word_wrap(header, Miniparse.control(:width_display))
        text += "\n\n"
        text += help_usage_format(
                    "#{cmd} #{command_brokers[cmd].help_usage}")
        text += "\n\nOptions:\n"
        text += command_brokers[cmd].help_desc
        
        puts text
        exit ERR_HELP_REQ
      else
        raise ArgumentError, "use 'help <command>' to get help"
      end
    end
  end
  
  def help_usage_format(right_text)
    left_text = "usage: #{File.basename($PROGRAM_NAME)}"
    if Miniparse.control(:formatted_help)
      width_display = Miniparse.control(:width_display)
      width_left = left_text.size
      Miniparse.two_cols_word_wrap(left_text, ' ', right_text, 
          width_left, width_display - 1 - width_left)
    else
      left_text + " " + right_text
    end
  end
  
end



end
