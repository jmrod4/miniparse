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

  attr_reader :_spec, :_desc, :_block 

  # uses args:
  #   :spec
  #   :desc
  def initialize(args, &block)
    Miniparse.debug args.inspect      if args[:debug]
     
    @_spec = args.fetch(:spec) 
    @_desc = args[:desc] 

    @name = self.class.spec_to_name(_spec)
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


  # @param arg is like an ARGV element
  # @return true if arg specifies this object
  def check(arg)
    raise NotImplementedError, 
        "#{self.class} cannot respond to '#{__method__}'"
  end

  # @return text of an option specification and description
  def help_desc
    return nil    unless _desc
    
    separator = '  '
    width_indent = Miniparse.control[:width_indent]
    width_left = Miniparse.control[:width_left] -
                 Miniparse.control[:width_indent]
    width_right = Miniparse.control[:width_display] - 
                  separator.size -
                  Miniparse.control[:width_left] 

    if Miniparse.control[:formatted_help]
      lines = Miniparse.two_cols_word_wrap_lines(
              _spec.to_s, separator, _desc, width_left, width_right)
      lines.collect! { |line|  " "*width_indent + line  }
      lines.join("\n")
    else
      s = "%*s" % [width_indent, separator]
      s += "%-*s" % [width_left, _spec]
      s += '  '
      s += _desc
    end
  end

end



class Command < InterfaceElement

  def self.spec_to_name(spec)
    spec_pattern_to_name(spec, /^(\w[\w-]+)$/)
  end

  def check(arg)
    arg == name.to_s
  end

end



# TODO FEATURE consider doing unambiguous matches for shortened options
# TODO FEATURE consider the option default value setting the type
# TODO FEATURE add option shortable:true
class Option < InterfaceElement
  
  attr_reader :value

  # uses args:
  #   :default
  def post_initialize(args)
    super(args)
    @value = args[:default]
  end

  def check(arg)
    arg_to_value(arg) != nil
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

end



class SwitchOption < Option

  def self.spec_to_name(spec)
    spec_pattern_to_name(spec, /^--(\w[\w-]+)$/)
  end

  attr_reader :_negatable

  # uses args:
  #   negatable:true
  def post_initialize(args)
    super(args)
    @_negatable = args[:negatable]
    @_negatable = Miniparse.control[:autonegatable]    if _negatable.nil?
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
