module Miniparse


class InterfaceElement

  def self.spec_pattern_to_name(spec, pattern)
    if spec =~ pattern
      $1.to_sym
    else
      nil
    end
  end

  def self.spec_to_name(spec)
    raise NotImplementedError, 
        "#{self.class} cannot respond to '#{__method__}'"
  end

  def self.valid_spec(spec)
    spec_to_name(spec) != nil
  end

  attr_reader :name

  attr_reader :_block

  def initialize(spec, &block)
    @name = self.class.spec_to_name(spec)
    raise SyntaxError, "invalid specification '#{spec}'"    if name.nil?
    @_block = block
  end

  # runs the associated block with specified arguments
  #
  # @param args is arguments passed to the block
  def run(*args)
    _block.call(*args)    if _block 
  end

end



class Command < InterfaceElement

  def self.spec_to_name(spec)
    spec_pattern_to_name(spec, /^(\w[\w-]+)$/)
  end

  # @param arg is like an ARGV element
  # @return true if arg specifies this object
  def check(arg)
    arg == name.to_s
  end

end



class Option < InterfaceElement
  
  attr_reader :_short_help, :_desc

  attr_reader :value

  def initialize(spec, description, default:nil, &block)
    @_short_help = spec
    @_desc = description
    @value = @default = default
    super(spec, &block)
  end

  def arg_to_value(spec)
    raise NotImplementedError, 
        "#{self.class} cannot respond to '#{__method__}'"
  end

  def parse_value(arg)
    val = arg_to_value(arg)
    if val != nil
      @value = val
      run(val)
    end
    val
  end

  # @param arg is like an ARGV element
  # @return true if arg specifies this object
  def check(arg)
    arg_to_value(arg) != nil
  end

  def help_desc
    "  #{_short_help}  #{_desc}"    if _desc
  end

end



class SwitchOption < Option

  def self.spec_to_name(spec)
    spec_pattern_to_name(spec, /^--(\w[\w-]+)$/)
  end

  def arg_to_value(arg)
    if arg == "--#{name}"
      true
    elsif arg == "--no-#{name}"
      false
    else
      nil
    end
  end

  def help_usage
    "[--[no-]#{name}]"
  end

end



class FlagOption < Option

  def self.spec_to_name(spec)
    spec_pattern_to_name(spec, /^--(\w[\w-]+)[=| ]\S+$/)
  end

  # @param arg is like an ARGV element
  # @return true if arg specifies this object
  def check(arg)
     super(arg) || (arg =~ /^--#{name}$/)
  end

  def arg_to_value(arg)
    if arg =~ /^--#{name}[=| ](.*)$/
      $1
    else
      nil
    end
  end

  def help_usage
    "[#{_short_help}]"
  end

end


end
