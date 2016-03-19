module Miniparse
  

  
# @private  
# @param right_text [string] is a usage text to be displayed to the right
# @return [string] the formatted text to the right with an usage header to the left 
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



end
