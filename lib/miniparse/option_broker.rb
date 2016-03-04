module Miniparse 



class OptionBroker

  attr_reader :parsed_values

  def initialize
    @parsed_values = {}
    @added_options = {}
  end

  def add_option(args, &block)
    opt = new_option(args, &block)
    # FEATURE duplicate option overwrite the old one
    # NOTE defining a switch option and a flag option with the same name doesn't work (the first one gets overwritten)
    if opt.shortable
      duplicate = added_options.values.collect { |o|  
         (o.shortable && o.name.to_s[0] == opt.name.to_s[0])? o.name : nil }
      duplicate.compact!
      unless duplicate.empty? || duplicate.include?(opt.name)
        raise SyntaxError, "shortable option '#{opt.name}' conflicts with previously defined '" + duplicate.join(', ') + "'"
      end
    end
    @added_options[opt.name] = opt
  end

  # @param argv is like ARGV but just for this broker
  # @return unprocessed arguments
  def parse_argv(argv)
    av = argv.dup
    rest_argv = []
    while av.size > 0
      arg = av.shift
      opt = check_arg(arg)
      if opt
        val = opt.parse_value(arg)
	    if val.nil? && (av.size > 0) && (av[0][0] != '-')
	      new_arg = arg + "=" + av.shift
	      val = opt.parse_value(new_arg)
        end
	    if val.nil?
        raise ArgumentError, "#{opt.class} invalid invocation format '#{arg}'"
	    end
      else
        if Miniparse.control(:raise_on_unrecognized) && (arg[0] == '-')
          raise ArgumentError, "unrecognized option '#{arg}'"
        end
        rest_argv << arg
      end
    end
    update_parsed_values
    rest_argv
  end
 
  def help_usage
    helps = added_options.values.collect do |opt|
      opt.help_usage 
    end
    helps.compact.join(" ")
  end

  def help_desc
    helps = added_options.values.collect { |opt| opt.help_desc }
    helps.compact.join("\n")
  end

protected

  attr_reader :added_options

  def new_option(args, &block)
    if SwitchOption.valid_spec args[:spec]
      SwitchOption.new(args, &block)
    elsif FlagOption.valid_spec args[:spec]
      FlagOption.new(args, &block)
    else
      raise SyntaxError, 
          "unknown or invalid option specification '#{args[:spec]}'"
    end
  end

  def check_arg(arg)
    match = added_options.values.collect { |opt|  opt.check(arg) ? opt : nil }
    match.compact!
    if match.size > 1
      # NOTE this shouldn't be happening, just a sanity check
      names = match.collect { |opt|  opt.name }
      raise "Ambiguous options: '" + names.join(', ') + "'"
    elsif match.size > 0
      match[0]
    else      
      nil
    end
  end

  def update_parsed_values
    @parsed_values = {}
    added_options.values.each do |opt| 
      @parsed_values[opt.name] = opt.value    if opt.value != nil
    end
    parsed_values
  end

end



end
