module Miniparse

  class Interface

    def self.get_prefix(s)
      s =~ /^(-?-?\w[\w-]*)/
      $1
    end

    def self.get_name(s)
      s =~ /^-?-?(\w[\w-]*)/
      $1
    end

    # external -> contract
    attr_reader :name

    # internal -> can refactor any time
    attr_reader :_short_help, :_description, :_block

    def initialize(short_help, description=nil, &block)
      @name = self.class.get_name(short_help).to_sym
      @_short_help = short_help
      @_description = description
      @_block = block
    end

    # @return the recognizable part of the element if seen in a command line argument  
    def prefix
      n = self.class.get_prefix _short_help 
      #puts "sh: #{short_help} prefix: #{n}"
    end

    # runs the associated block
    #
    # @param arguments passed to the block
    def run(*args)
      _block.call(*args)    if _block 
    end
  
  end

end #module


module Miniparse


# TODO FEATURE consider using auto short options
# TODO FEATURE consider be able to specify short options
# TODO FEATURE consider doing unambiguous matches for shortened options
# TODO FEATURE consider the option default value setting the type
  class Option < Interface

    attr_reader :value

    attr_reader :_default, :_required
    
    def initialize(short_help, description=nil, default:nil, required:false, &block)
      super(short_help, description, &block)
      @value = @_default = default
      @_required = required
    end

    # runs the associated block (passing the option value to it)    
    def run
      super(value)
    end
    
    # @param arg, like an element of ARGV
    # @return true if arg corresponds to this option
    def check(arg)
      prefix == self.class.get_prefix(arg)
    end

    ############ PARSING
    # allowed:
    # 
    # * for switches:
    #   --option
    #   --no-option
    # * for flags
    #   --option <value>
    #   --option=<value>    
    #
    # FEATURE: <value> can be anything, even spaces 
    # as for example if invoked in the command line as: "--option=    "
    #
    # raise exceptions:
    # 
    # * for switches and flags
    #   --option= 
    # * for flags
    #   --option
    # * for switches
    #   --option=<value>
    #   --option <value>
    #
    # @param arg, like an element of ARGV
    # @return nil if arg doesn't correspond to this option 
    # @return set value
    def parse(arg)
      return nil    unless check(arg) 
      set_value(arg)
    end

    # extracts and sets the value from arg
    #
    # @param arg, like an element of ARGV
    # @return set value    
    def set_value(arg)
      arg_name, val = self.class.format_to_name_value(arg)
      raise "can't get value from invalid format option '#{arg}'"    if val.nil?
      raise "#{name} option expected '#{arg}'"    if name.to_s != arg_name 
      @value = val
    end
    
    # @return an option formal specification like the ones on usage string
    def specification
      s = _short_help.strip
      s = '[' + s + ']'    unless _required
    end
    
  end
      
end # module


module Miniparse

  class OptionSwitch < Option

    # @param s, a string (like an element of ARGV)
    # @return an array with extracted option name and value  
    def self.format_to_name_value(s)
      s =~ /^--(no-)?(\w[\w-]*)$/
      [$2, $1.nil?]
    end

    # @param s, a string (like an element of ARGV)
    # @return true if format correct for a switch
    def self.valid_format(s)
      name, val = format_to_name_value(s)
      !name.nil?
    end

    def check(arg)
      return true    if super(arg)
      return false   unless arg =~ /^--no-(.*)/
      #remove negative prefix and try to check again
      super("--#{$1}")
    end
    
    # TODO consider adding "[no-]" to the specification
    
  end
end # module


module Miniparse
  class OptionFlag < Option
    
    # @param s, a string (like an element of ARGV)
    # @return an array with extracted option name and value  
    def self.format_to_name_value(s)
      s =~ /^--(\w[\w-]*)[ |=](.+)$/
      [$1, $2]
    end

    # @param s, a string (like an element of ARGV)
    # @return true if format correct for a flag
    def self.valid_format(s)
      name, val = format_to_name_value(s)
      !name.nil?
    end
    
  end

end #module

