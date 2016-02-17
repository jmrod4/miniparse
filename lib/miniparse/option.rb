
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
      if not (@short_help =~ /^--([\w\-]+)( |=)\w+$/).nil?
        @name = $1.to_sym
	      @is_switch = false
	      @value_required = @value.nil?
      elsif not (@short_help =~ /^--([\w\-]+)$/).nil?
        @name = $1.to_sym
	      @is_switch = true
      else 
        raise "unknown format for option short help: #{@short_help}"
      end
    end

    def run
      @block.call self
    end 
  end

end