module Miniparse



class InterfaceElement

  def self.valid_spec(spec)
    spec_to_name(spec) != nil
  end

  # subclass need to overide 
  def self.spec_to_name(spec)
    raise NotImplementedError, 
        "#{self.class} cannot respond to '#{__method__}'"
  end

  def self.spec_pattern_to_name(spec, pattern)
    (spec =~ pattern)  ?  $1.to_sym  :  nil
  end

  attr_reader :name, :desc

  # runs the associated block with specified arguments
  #
  # @param args is arguments passed to the block
  def run(*args)
    block.call(*args)    if block 
  end

  # @param arg is like an ARGV element
  # @return true if arg specifies this object
  def check(arg)
    raise NotImplementedError, 
        "#{self.class} cannot respond to '#{__method__}'"
  end

  # @return text of an option specification and description
  def help_desc
    return nil    unless desc
    
    separator = '  '
    width_indent = Miniparse.control(:width_indent)
    width_left = Miniparse.control(:width_left) -
                 Miniparse.control(:width_indent)
    width_right = Miniparse.control(:width_display) - 
                  separator.size -
                  Miniparse.control(:width_left)

    if Miniparse.control(:formatted_help)
      lines = Miniparse.two_cols_word_wrap_lines(
              spec.to_s, separator, new_desc,
              width_left, width_right)
      lines.collect! { |line|  " "*width_indent + line  }
      lines.join("\n")
    else
      s = "%*s" % [width_indent, separator]
      s += "%-*s" % [width_left, spec]
      s += '  '
      s += desc + new_desc
    end
  end

protected

  # subclass hook for initializing
  def post_initialize(args)
    nil
  end 
     
  # subclass hook for changing description
  def new_desc
    desc
  end
  
  attr_reader :spec, :block 

  # uses args:
  #   :spec
  #   :desc
  def initialize(args, &block)
    @spec = args.fetch(:spec) 
    @desc = args[:desc] 
    @block = block
    @name = self.class.spec_to_name(spec)
    raise SyntaxError, "invalid specification '#{spec}'"    if name.nil?
    post_initialize(args)
  end

end



class Command < InterfaceElement

  def check(arg)
    arg == name.to_s
  end

protected

  def self.spec_to_name(spec)
    spec_pattern_to_name(spec, /\A(\w[\w-]+)\z/)
  end

end



# TODO FEATURE consider doing unambiguous matches for shortened options
# TODO FEATURE consider the option default value setting the type
# TODO FEATURE add option shortable:true
class Option < InterfaceElement
  
  attr_reader :value

  def check(arg)
    arg_to_value(arg) != nil
  end

  def parse_value(arg)
    val = arg_to_value(arg)
    if val != nil
      @value = val
      run(val)
    end
    val
  end

  def arg_to_value(arg)
    raise NotImplementedError, "#{self.class} cannot respond to '#{__method__}'"
  end

protected

  # uses args:
  #   :default
  def post_initialize(args)
    super(args)
    @value = args[:default]
  end

end



class SwitchOption < Option

  def self.spec_to_name(spec)
    spec_pattern_to_name(spec, /\A--(\w[\w-]+)\z/)
  end

  def help_usage
    negatable  ?  "[--[no-]#{name}]"  :  "[--#{name}]"
  end
  
  def arg_to_value(arg)
    if arg == "--#{name}"
      true
    elsif negatable && arg == "--no-#{name}"
      false
    else
      nil
    end
  end
  
protected

  attr_reader :negatable

  # uses args:
  #   negatable:true
  def post_initialize(args)
    super(args)
    @negatable = args[:negatable]
    @negatable = Miniparse.control(:autonegatable)    if negatable.nil?
  end

end



class FlagOption < Option

  def self.spec_to_name(spec)
    spec_pattern_to_name(spec, /\A--(\w[\w-]+)[=| ]\S+\z/)
  end
  
  # @param arg is like an ARGV element
  # @return true if arg specifies this option
  def check(arg)
     super(arg) || (arg =~ /\A--#{name}\z/)
  end

  def help_usage
    "[#{spec}]"
  end

  def arg_to_value(arg)
    (arg =~ /\A--#{name}[=| ](.+)\z/)  ?  $1  :  nil
  end
  
protected

  def new_desc
    desc + ( value ? " (#{value})" : "" )
  end

end



end
