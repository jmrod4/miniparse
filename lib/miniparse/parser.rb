module Miniparse

  # error exit codes
  ERR_HELP_REQ = 1
  
  # behaviour controlers
  ERROR_on_unrecognized_option = true

  
  class Parser
    
    def initialize
      @options_long = []
      @commands = []
      @index = {}
      @options = {}
    end
    
    
    ######### DEFINE INTERFACE
    
    def add(*args, &block)
      raise "empty interface element"    if args.empty?
      short_help = args[0]
      if OptionSwitch.format?(short_help)
        @options_long << OptionSwitch.new(*args, &block)
        @index[@options_long[-1].prefix] = @options_long[-1]       
      elsif OptionTag.format?(short_help)
        @options_long << OptionTag.new(*args, &block)
        @index[@options_long[-1].prefix] = @options_long[-1]       
     elsif Command.format?(short_help)
        @commands << Command.new(*args, &block)
        @index[@commands[-1].prefix] = @commands[-1]       
     else
        raise "unrecognized interface element format #{short_help}"
      end
    end
  
 
    ########## PARSE

    def parse(argv)
      parse! argv.dup
    end
    
    def parse!(argv)
      # FIXME unshift for flag option in two arguments
      new_argv = []
      while argv.size > 0
        arg = argv.shift
        elem = @index[Miniparse.get_prefix(arg)]
        if elem && (arg[0] == '-') 
          if elem.switch? 
            raise "wrong option format '#{arg}'"    unless elem.format?(arg)
          
          else
          
          end
        elsif elem
          #TODO TODO command 
          raise "sanity check"
        else
          new_argv << argv
        end
      end
      update_options
      argv.replace new_argv   
    end 

    
    ########## GET DATA
    
    def options
      update_options    if @options.empty?
      @options      
    end
    
    def update_options
      @options_long.each do |opt|
        @options[opt.name] = opt.value    if not opt.value.nil?
      end
      @options
    end
    
    
  end
  
end



# module Miniparse

  # # error exit codes
  # ERR_HELP_REQ = 1


  # class Parser
	   
    # attr_reader :options_status

    # def initialize
      # @options_status = {}
      # @options = []
      # add("--help") { puts msg_help; exit ERR_HELP_REQ }
    # end

    # ########## DEFINE INTERFACE

    # def add(*args, &block)
      # if args.size > 0 && args[0][0]=='-'
        # option = Option.new(*args, &block)
        # @options << option
      # else
        # raise "unknown interface element #{args[0]} (did you mean '--option'?)"
      # end
    # end

    # ########## PARSE

    # def parse(argv)
      # parse! argv.dup
    # end
    
    # def parse!(argv)
      # new_argv = []
      # while argv.size > 0
        # arg = argv.shift
        # value = parse_options(arg)
        # new_argv << arg    if value.nil?
      # end
      # fill_options_status
      # argv.replace new_argv
    # end

    # def parse_options(arg)
      # # match each option with arg
      # @options.each do |opt|
        # value = opt.matches? arg
        # opt.run  if (not value.nil?) && value
        # return value  unless value.nil?
      # end
      # # raise if possible bad option!!
      # if arg =~ /^(--.*)\s*\Z/
        # raise "unrecognized option '#{$1}'"
      # end
      # #puts "unparsed args: >#{arg}<"
      # # returns nil if none option matched
      # nil
    # end  
    
    # def fill_options_status
      # @options.each do |opt|  
        # options_status[opt.name] = opt.value if not opt.value.nil?
      # end
    # end
    
    # ########## USAGE
    
    # @@width_indent = 3
    # @@width_left = 20
    # @@width_scr = 78

    # def msg_usage_options
      # s = ""
      # @options.each do |opt|
        # s << "[#{opt.short_help}] "
      # end
      # s
    # end

    # def msg_usage
      # app_name = "myname"
      # left = "usage: #{app_name}" 
      # right = "#{msg_usage_options}"
      # Miniparse.two_cols_word_wrap(left, ' ', right, left.size, @@width_scr)
    # end  
   
    # def msg_help
      # s = "#{msg_usage}\n"
      # @options.each do |opt|
        # next if opt.desc.nil? && opt.value.nil?
        # desc = ((opt.desc.nil?)? "" : opt.desc) 
	      # desc << " (default: #{opt.value})"  unless opt.value.nil?
	      # s << "\n"
        # s << Miniparse.two_cols_word_wrap((' ' * @@width_indent) + opt.short_help, 
            # ' ', desc, @@width_left, @@width_scr)
      # end
      # s
    # end

  # end

# end


