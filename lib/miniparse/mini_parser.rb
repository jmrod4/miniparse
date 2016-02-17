module Miniparse

  # error exit codes
  ERR_HELP_REQ = 1


  class Parser
	   
    attr_reader :options_status

    def initialize
      @options_status = {}
      @options = []
      add("--help") { puts msg_help; exit ERR_HELP_REQ }
    end

    ########## DEFINE INTERFACE

    def add(*args, &block)
      if args.size > 0 && args[0][0]=='-'
        option = Option.new(*args, &block)
        @options << option
      else
        raise "unknown interface element #{args[0]} (did you mean '--option'?)"
      end
    end

    ########## PARSE

    def parse(argv)
      parse! argv.dup
    end
    
    def parse!(argv)
      new_argv = []
      while argv.size > 0
        arg = argv.shift
        value = parse_options(arg)
        new_argv << arg    if value.nil?
      end
      fill_options_status
      argv.replace new_argv
    end

    def parse_options(arg)
      # match each option with arg
      @options.each do |opt|
        value = opt.matches? arg
        opt.run  if (not value.nil?) && value
        return value  unless value.nil?
      end
      # raise if possible bad option!!
      puts "<#{arg}>"
      if arg =~ /^(--.*)\s*\Z/
        raise "unrecognized option '#{$1}'"
      end
      # returns nil if none option matched
      nil
    end  
    
    def fill_options_status
      @options.each do |opt|  
        options_status[opt.name] = opt.value if not opt.value.nil?
      end
    end
    
    ########## USAGE
    
    @@width_indent = 3
    @@width_left = 20
    @@width_scr = 78

    def msg_usage_options
      s = ""
      @options.each do |opt|
        s << "[#{opt.short_help}] "
      end
      s
    end

    def msg_usage
      app_name = "myname"
      left = "usage: #{app_name}" 
      right = "#{msg_usage_options}"
      Miniparse.two_cols_word_wrap(left, ' ', right, left.size, @@width_scr)
    end  
   
    def msg_help
      s = "#{msg_usage}\n"
      @options.each do |opt|
        next if opt.desc.nil? && opt.value.nil?
        desc = ((opt.desc.nil?)? "" : opt.desc) 
	      desc << " (default: #{opt.value})"  unless opt.value.nil?
	      s << "\n"
        s << Miniparse.two_cols_word_wrap((' ' * @@width_indent) + opt.short_help, 
            ' ', desc, @@width_left, @@width_scr)
      end
      s
    end

  end

end


