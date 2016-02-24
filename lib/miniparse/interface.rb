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

  attr_reader :_block, :_desc

  # uses args:
  #   :spec
  #   :desc
  def initialize(args, &block)
    Miniparse::debug args.inspect      if args[:debug]
     
    spec = args.fetch(:spec) 
    @_desc = args[:desc] 

    @name = self.class.spec_to_name(spec)
    raise SyntaxError, "invalid specification '#{spec}'"    if name.nil?
    @_block = block
    post_initialize(args)
  end

  def post_initialize(args)
    nil
  end 

  # runs the associated block with specified arguments
  #
  # @param args is arguments passed to the block
  def run(*args)
    _block.call(*args)    if _block 
  end

  def help_desc
    "  #{_spec}  #{_desc}"    if _desc
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



# TODO FEATURE consider doing unambiguous matches for shortened options
# TODO FEATURE consider the option default value setting the type
# TODO FEATURE add option shortable:true
class Option < InterfaceElement
  
  attr_reader :_spec, :_desc

  attr_reader :value

  # uses args:
  #   :default
  #   :spec  
  def post_initialize(args)
    super(args)
    @_spec = args[:spec]
    @value = args[:default]
  end

  def arg_to_value(arg)
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

end



class SwitchOption < Option

  def self.spec_to_name(spec)
    spec_pattern_to_name(spec, /^--(\w[\w-]+)$/)
  end

  attr_reader :_negatable

  # used args:
  #   negatable:true
  def post_initialize(args)
    super(args)
    @_negatable = args[:negatable]
    @_negatable = true    if _negatable.nil?
  end


  def arg_to_value(arg)
    if arg == "--#{name}"
      true
    elsif _negatable && arg == "--no-#{name}"
      false
    else
      nil
    end
  end

  def help_usage
    if _negatable
      "[--[no-]#{name}]"
    else
      "[--#{name}]"
    end
  end

end


class FlagOption < Option

  def self.spec_to_name(spec)
    spec_pattern_to_name(spec, /^--(\w[\w-]+)[=| ]\S+$/)
  end

  # @param arg is like an ARGV element
  # @return true if arg specifies this option
  def check(arg)
     super(arg) || (arg =~ /^--#{name}$/)
  end

  def arg_to_value(arg)
    if arg =~ /^--#{name}[=| ](.+)$/
      $1
    else
      nil
    end
  end

  def help_usage
    "[#{_spec}]"
  end

end


end
