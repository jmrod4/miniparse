module Miniparse

  # error exit codes
  ERR_HELP_REQ = 1
  
  # behaviour controlers
  ERROR_on_unrecognized_option = true

end #module
  
module Miniparse

  class OptionBroker
    
    def self.find_option_class(short_help)

      if OptionSwitch.valid_format(short_help)
        OptionSwitch
      elsif OptionFlag.valid_format(short_help)
        OptionFlag
      else
        nil
      end
    end

    attr_reader :options_added, :options_parsed
    
    def initialize
      @options_added = []
      @options_parsed = {}
    end
    
    def new_option(short_help, *args, &block)
      cls = self.class.find_option_class(short_help)
      raise "invalid format for option '#{short_help}'"    if cls.nil?
      cls.new(short_help, *args, &block)
    end
    
    def add_option(*args, &block)
      opt = new_option(*args, &block)
      @options_added << opt
      opt
    end
    
    
    def check_arg(arg)
      options_added.each do |opt|
        return opt    if check(arg)
      end
      return nil
    end
    
    def parse_argv(argv)
      rest_argv = []
      av = argv.dup
      while av.size > 0
        arg = av.shift
        opt = check_arg(arg)
        next    unless opt
        val = opt.parse(arg)
        if val.nil?
          if && av.size > 0 && opt.class 
            val = parse_arg(arg + ' ' + arg.shift)
          
        else
          rest_argv << arg
        end
      end
      rest_argv
    end
  end

end #module


module Miniparse
  
  class Parser
        
    attr_reader :global_broker, :commands, :current_command
  
    def initialize
      @global_broker = OptionBroker.new
      @commands = {}
      @current_command = nil
    end
    
    def current_broker
      if current_command
        commands[current_command].broker
      else
        global_broker
      end
    end

    def split_argv(argv)
      if commands.size > 0
        global_argv = []
        commands.keys.each do |cmd|
          index = argv.index(cmd.to_s)
          return [[], cmd, argv[1..-1]]    if index == 0 
          return [argv[0..i-1], cmd, argv[i+1..-1]]    if index
        end
      end
      [argv, nil, []]
    end
    
    def add_option(short_help, *args, &block)
      current_broker.add_option(short_help, *args, &block)
    end
    
    def add_command(short_help, *args, &block)
      # TODO consider check and raise for duplicate commands
      cmd = Command.new(short_help, *args, &block)
      @commands[cmd.name] = cmd
      @current_command = cmd.name
    end
    
    def parse(argv)    
      global_argv, @command_parsed, command_argv = split_argv(argv)
      @global_rest_argv = global_broker.parse_argv(global_argv)
      
      if command_parsed
        @command_rest_argv = 
             commands[command_parsed].broker.parse_argv(command_argv)     
      else
        @command_rest_argv = []
      end

      @global_rest_argv
    end
 
    def parse!(argv)
      argv.replace parse(argv)
    end
 
    # @return parsed (i.e. specified) global options
    def options
      global_broker.options_parsed
    end
    # @return  parsed (i.e. specified) command options
    def command_options
      commands[command_parsed].broker.options_parsed
    end
    
    # @return parsed (i.e. specified) command or nil if no command
    def command_parsed
      @command_parsed
    end
    
    # @return after parsing (i.e. specified) rest of arguments 
    def args
      @global_rest_argv
    end
    # @return after parsing (i.e. specified) rest of arguments 
    def command_args
      @command_rest_argv
    end
    
    
  end
  
end #module

