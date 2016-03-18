# TODO consider inserting here instructions about how to use or how to find help

# other modules
require "miniparse/word_wrap"

module Miniparse
  # error exit codes
#  module ErrorCodes
    ERR_HELP_REQ = 1
    ERR_ARGUMENT = 2
#  end
#  include ErrorCodes
end

# module miniparse
require "miniparse/command"
require "miniparse/commander"
require "miniparse/control"
require "miniparse/option_broker"
require "miniparse/parser"
require "miniparse/version"



module Miniparse
  

  
def self.help_usage_format(right_text)
  left_text = "usage: #{File.basename($PROGRAM_NAME)}"
  if Miniparse.control(:formatted_help)
    width_display = Miniparse.control(:width_display)
    width_left = left_text.size
    WordWrap.two_cols_word_wrap(left_text, ' ', right_text, 
        width_left, width_display - 1 - width_left)
  else
    left_text + " " + right_text
  end
end
 

def self.debug(msg)
  puts "\nDEBUG #{caller[0]}: #{msg}" 
end

  

end



