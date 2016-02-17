module Miniparse

  # error exit codes
  ERR_HELP_REQ = 1


  class Parser
	   
    attr_reader :options, :options_parsed

    def initialize
      @options_parsed= {}
      @options = []
      add("--help") { puts msg_help; exit ERR_HELP_REQ }
    end

    ########## DEFINE INTERFACE

    def add(*args, &block)
      if args.size > 0 && args[0][0]=='-'
        option = Option.new(*args, &block)
        options << option
      else
        raise "unknown interface element #{args[0]} (did you mean '--option'?)"
      end
    end

    ########## PARSE

    def parse(argv)
      parse! argv.dup
    end

    def parse!(argv)
       
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


