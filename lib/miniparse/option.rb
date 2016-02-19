module Miniparse

  def self.get_prefix(s)
    s =~ /^(-?-?\w[\w-]*)/
    $1
  end
  
  def self.get_name(s)
    s =~ /^-?-?(\w[\w-]*)/
    $1
  end

  
  class Option
 
    attr_reader :value
    
    def initialize(short_help, description=nil, default=nil, required=false, &block)
      @short_help = short_help
      @desc = description
      @value = @default = default
      @required = required
    end
    
    def name
      Miniparse.get_name @short_help
      #puts "sh: #{@short_help} name: #{n}"
    end
    
    def prefix
      n = Miniparse.get_prefix @short_help 
      #puts "sh: #{@short_help} prefix: #{n}"
    end
  
  end
  
  
  class OptionSwitch < Option
  
    # return an array with name and value  
    def self.format_to_name_value(s)
      s =~ /^--(no-)?(\w[\w-]*)$/
      [$2, $1.nil?]
    end

    # return true if format correct
    def self.format?(s)
      name, val = format_to_name_value(s)
      !name.nil?
    end

    
    def initialize(*args, &block)
      super 
    end
    
  end
  
  
  class OptionTag < Option
  
    # return an array with name and value  
    def self.format_to_name_value(s)
      s =~ /^--(\w[\w-]*)[ |=](.+)$/
      [$1, $2]
    end

    # return true if format correct
    def self.format?(s)
      name, val = format_to_name_value(s)
      !name.nil?
    end
  
  
    def initialize(*args, &block)
      super
    end
  
  end

end


# module Miniparse
# # NOTE
# # the option default value set the type

  # class Option
    
    # attr_reader :short_help, :value, :desc
    # attr_reader :name, :is_switch

    # def initialize(short_help, default=nil, description=nil, &block)
      # @short_help = short_help 
      # process_short_help
      # @value = default
      # @value_class = default.class
      # @desc = description
      # @block = block
    # end

    # def process_short_help
      # if @short_help =~ /^--([\w\-]+)[ |=]\w+$/
        # @name = $1.to_sym
	      # @is_switch = false
      # elsif @short_help =~ /^--([\w\-]+)$/
        # @name = $1.to_sym
	      # @is_switch = true
      # else 
        # raise "unknown format for option short help: #{@short_help}"
      # end
    # end
   
    # def run
      # @block.call @value   if @block
    # end 
   
    # ############ PARSING
    
    # # allowed:
    # # for switches:
    # #   --option
    # #   --no-option
    # # for flags
    # #   --option <value>
    # #   --option=<value>    

    # # FEATURE: <value> can be anything, even spaces 
    # #  as for example if invoked in the command line as: "--option=    "
    
    # # raise exceptions:
    # # for switches and flags
    # #   --option= 
    # # for flags
    # #   --option
    # # for switches
    # #   --option=<value>
    # #   --option <value>
    
    # # TODO FEATURE: consider using auto short options
    # # TODO FEATURE: consider be able to specify short options
    # # TODO FEATURE: consider doing unambiguous matches for shortened options
    
    # def matches?(s)
      # # returns option value or nil if s doesn't match this option
      
      # if s =~ /^--(no-)?#{@name}$/
        # raise "missing value for option '#{@name}'"    unless @is_switch
        # @value = $1.nil?
      # elsif s =~ /^--#{@name}[ |=](.*)$/
        # raise "value specified for switch option '#{name}'"    if @is_switch
        # raise "missing value for flag option '#{name}'"    if $1 == ""
        # @value = $1
      # else
        # # not this option
        # nil
      # end

    # end
    
  # end

# end
