module Miniparse



class Command

  def self.spec_to_name(spec)
    spec_pattern_to_name(spec, /\A(\w[\w-]*)\z/)
  end
  def self.valid_spec(*args); spec_to_name(*args); end

  attr_reader :name, :desc

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

  # runs the associated block with specified arguments
  #
  # @param args is arguments passed to the block
  def run(*args)
    block.call(*args)    if block 
  end

  # @param arg is like an ARGV element
  # @return true if arg specifies this object
  def check(arg)
    arg.to_s == name.to_s
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
              spec.to_s + add_spec, separator, 
              desc + add_desc,
              width_left, width_right)
      lines.collect! { |line|  " "*width_indent + line  }
      lines.join("\n")
    else
      s = "%*s" % [width_indent, separator]
      s += "%-*s" % [width_left, spec.to_s + add_spec]
      s += '  '
      s += desc + add_desc
    end
  end

protected

  def self.spec_pattern_to_name(spec, pattern)
    (spec =~ pattern)  ?  $1.to_sym  :  nil
  end

private_class_method :spec_pattern_to_name

  attr_reader :spec, :block 

  # subclass hook for initializing
  def post_initialize(args); nil; end 
     
  # subclass hook for changing description/specification
  def add_desc; ""; end
  def add_spec; ""; end

end



# TODO FEATURE consider doing unambiguous matches for shortened options
# TODO FEATURE consider the option default value setting the type
class Option < Command
  
  attr_reader :value, :shortable

  def check(arg)
    arg_to_value(arg) != nil
  end

  def arg_to_value(arg)
    raise NotImplementedError, "#{self.class} cannot respond to '#{__method__}'"
  end

  def parse_value(arg)
    val = arg_to_value(arg)
    if val != nil
      @value = val
      run(val)
    end
    val
  end

  def help_usage
    raise NotImplementedError, "#{self.class} cannot respond to '#{__method__}'"
  end

protected
  
  # uses args:
  #   :default
  def post_initialize(args)
    super(args)
    @value = args[:default]
    @shortable = args.fetch(:shortable, Miniparse.control(:autoshortable))
  end
  
  def add_spec
    shortable ? ', -' + name.to_s[0] : ""
  end

end



class SwitchOption < Option

  def self.spec_to_name(spec)
    spec_pattern_to_name(spec, /\A--(\w[\w-]+)\z/)
  end

  def arg_to_value(arg)
    if arg == "--#{name}"
      true
    elsif negatable && (arg == "--no-#{name}")
      false
    elsif shortable && (arg == '-' + name.to_s[0])
      true
    else
      nil
    end
  end
  
  def help_usage
    negatable  ?  "[--[no-]#{name}]"  :  "[--#{name}]"
  end
  
protected

  attr_reader :negatable

  # uses args:
  #   negatable:true
  def post_initialize(args)
    super(args)
    @negatable = args.fetch(:negatable, Miniparse.control(:autonegatable))
  end

  def add_desc
    value ? " (on by default)" : "" 
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

  def arg_to_value(arg)
    if arg =~ /\A--#{name}[=| ](.+)\z/
      $1
    elsif shortable && (arg =~ /\A-#{name.to_s[0]}[=| ](.+)\z/)
      $1
    else
      nil
    end
  end
  
  def help_usage
    "[#{spec}]"
  end

protected

  def add_desc
    value ? " (#{value})" : "" 
  end

end



end
