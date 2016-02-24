module Miniparse 


class OptionBroker

  attr_reader :parsed_options

  attr_reader :_added_options

  def initialize
    @parsed_options = {}
    @_added_options = []
  end

  def add_option(*args, &block)
    opt = _new_option(*args, &block)
    @_added_options << opt
  end

  # @param argv is like ARGV but just for this broker
  # @return unprocessed arguments
  def parse_argv(argv)
    av = argv.dup
    rest_argv = []
    while av.size > 0
      arg = av.shift
      opt = _check_arg(arg)
      if opt
        val = opt.parse_value(arg)
	if val.nil? && av.size > 0 && av[0][0] != '-'
	  new_arg = arg + "=" + av.shift
	  val = opt.parse_value(new_arg)
        end
	if val.nil?
          raise ArgumentError,
	      "#{opt.class} invalid invocation format '#{arg}'"
	end
      else
        if (Miniparse.controls[:error_unrecognized]) && (arg[0] == '-')
          raise ArgumentError, 
	      "unrecognized option '#{arg}'"
        end
        rest_argv << arg
      end
    end
    _update_parsed_options
    rest_argv
  end
 
  def help_usage
    helps = @_added_options.collect do |opt|
      opt.help_usage 
    end
    helps.compact.join(" ")
  end

  def help_desc
    helps = @_added_options.collect do |opt|
      opt.help_desc 
    end
    helps.compact.join("\n")
  end

  def _new_option(spec, desc, opts, &block)
    args = opts.merge(spec:spec, desc:desc)
    if SwitchOption.valid_spec(spec)
      SwitchOption.new(args, &block)
    elsif FlagOption.valid_spec(spec)
      FlagOption.new(args, &block)
    else
      raise SyntaxError, 
          "unknown or invalid option specification '#{spec}'"
    end
  end

  def _check_arg(arg)
    _added_options.each do |opt|
      return opt    if opt.check(arg)
    end
    nil
  end

  def _update_parsed_options
    @parsed_options = {}
    _added_options.each do |opt|
      if opt.value != nil
        @parsed_options[opt.name] = opt.value
      end
    end
  end

end


end
