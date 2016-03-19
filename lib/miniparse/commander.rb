module Miniparse

# TODO this class maybe does too much, separate a command broker or something similar


# @private
class Commander

  # command ready to add options to
  attr_reader :current_command_name
  # command found while parsing arguments
  attr_reader :parsed_command_name
  # remaining command args after parsing the options for the parsed command 
  attr_reader :parsed_args
  
  # @return [hash] parsed option values for the parsed command
  def parsed_values
    brokers[parsed_command_name].parsed_values  if parsed_command_name
  end
  
  # @return [Broker] current command broker or nil if there is not current command
  def current_broker
    brokers[current_command_name]
  end

  def initialize
    @commands = {}
    @brokers = {}
  end
    
  # @param args [hash] can have keys:
  #   * :name is the command name (ex. either "kill" or :kill)
  #   * :desc is a short description of the command
  #   * :opts are the options to apply to the command, can have keys: 
  #     * :no_options  indicates the command has no command line options
  # @return [Command] the command added
  def add_command(args, &block)
    spec = args[:spec]
    unless name = Command.spec_to_name(spec)
      raise SyntaxError, "unknown or invalid command specification '#{spec}'"
    end
    # only run before first command get added
    # and the user isn't trying to add his own help command
    add_help_command    if name != :help && commands.empty?
    cmd = Command.new(args, &block)
    # FEATURE if a command already exists it gets quietly overwritten (and its options lost)
    @commands[name] = cmd
    @brokers[name] = OptionBroker.new do
      puts help_command_text(name)
      exit ERR_HELP_REQ
    end
    @current_command_name = name    unless args[:no_options]
    cmd
  end  

  # @param argv [array] is ARGV like
  # @return [array] of argv parts: [global_argv, command_name, command_argv] 
  def split_argv(argv)
    index = index_command(argv)
    if index
      global_argv = (index == 0)  ?  []  :  argv[0..index-1]
      command_argv = argv[index+1..-1]
      [global_argv, Command.spec_to_name(argv[index]), command_argv]
    else  
      [argv, nil, []]
    end
  end
    
  # @param name [symbol] command name
  # @param argv [array] is ARGV like to parse
  # @return [array] #parsed_args
  def parse_argv(name, argv)
    cmd = commands.fetch(name)
    @parsed_command_name = cmd.name
    @parsed_args = brokers[cmd.name].parse_argv(argv)
    commands[cmd.name].run(parsed_args)
    parsed_args
  end
  
  # @return [string] the command general help for the commands in the commander 
  def help_desc
    text = ""
    if current_command_name
      names_wo_desc = []
      desc_texts = commands.sort.collect do |name, cmd| 
        if cmd.desc
          cmd.help_desc
        else
          names_wo_desc << name
          nil
        end
      end
      unless desc_texts.compact!.empty?
        text += "\nCommands:\n"
        text += desc_texts.join("\n") 
      end
      unless names_wo_desc.empty?
        text += "\nMore commands: \n"
        text += ' '*Miniparse.control(:width_indent)
        text += names_wo_desc.join(", ")
      end
    end
    text
  end
  
protected 

  attr_reader :commands, :brokers 
  
  # @param name [symbol] command name
  # @return [string] text help for the specified command
  def help_command_text(name)
    header = "Command #{name}:  #{commands[name].desc}"
    text = "\n"
    text += WordWrap.word_wrap(header, Miniparse.control(:width_display))
    text += "\n\n"
    text += Miniparse.help_usage_format(
        "#{name} #{brokers[name].help_usage}")
    if (options_desc = brokers[name].help_desc).size > 0
      text += "\n\nOptions:\n"
      text += options_desc
    end
    text += "\n\n"
    text
  end
  
  # adds a default help command
  # @return [void]
  def add_help_command
    add_command(spec: :help, desc: nil, no_options: true) do |args|
      index = index_command(args)
      if index
        name = args[index].to_sym
        puts help_command_text(name)
        exit ERR_HELP_REQ
      else
        raise ArgumentError, "no command specified, use 'help <command>' to get help"
      end
    end
  end

  # @param argv [array] is like ARGV
  # @return [int|nil] index number of the first found command, nil if not found
  def index_command(argv)
    commands.values.each do |cmd|
      index = argv.find_index  { |arg|  cmd.check(arg) }
      return index if    index
    end
    nil
  end

end



end
