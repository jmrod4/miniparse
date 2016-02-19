
module Miniparse
# NOTE
# the option default value set the type

  class Option
    
    attr_reader :short_help, :value, :desc
    attr_reader :name, :is_switch

    def initialize(short_help, default=nil, description=nil, &block)
      @short_help = short_help 
      process_short_help
      @value = default
      @value_class = default.class
      @desc = description
      @block = block
    end

    def process_short_help
      if @short_help =~ /^--([\w\-]+)[ |=]\w+$/
        @name = $1.to_sym
	      @is_switch = false
      elsif @short_help =~ /^--([\w\-]+)$/
        @name = $1.to_sym
	      @is_switch = true
      else 
        raise "unknown format for option short help: #{@short_help}"
      end
    end
   
    def run
      @block.call @value   if @block
    end 
   
    ############ PARSING
    
    # allowed:
    # for switches:
    #   --option
    #   --no-option
    # for flags
    #   --option <value>
    #   --option=<value>    

    # FEATURE: <value> can be anything, even spaces 
    #  as for example if invoked in the command line as: "--option=    "
    
    # raise exceptions:
    # for switches and flags
    #   --option= 
    # for flags
    #   --option
    # for switches
    #   --option=<value>
    #   --option <value>
    
    # TODO FEATURE: consider using auto short options
    # TODO FEATURE: consider be able to specify short options
    # TODO FEATURE: consider doing unambiguous matches for shortened options
    
    def matches?(s)
      # returns option value or nil if s doesn't match this option
      
      if s =~ /^--(no-)?#{@name}$/
        raise "missing value for option '#{@name}'"    unless @is_switch
        @value = $1.nil?
      elsif s =~ /^--#{@name}[ |=](.*)$/
        raise "value specified for switch option '#{name}'"    if @is_switch
        raise "missing value for flag option '#{name}'"    if $1 == ""
        @value = $1
      else
        # not this option
        nil
      end

    end
    
  end

end
