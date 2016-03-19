# @private
module WordWrap



# wrap a text at word boundaries
# 
# @param text is the text to wrap
# @param width is the maximum width allowed for on line before inserting line breaks
# @param reformat if true then the existing line breaks are removed and then the text wrapped
# @return text with line breaks inserted as necessary
def self.word_wrap(text, width, reformat:false)
  text = text.gsub(/\s*\n/, ' ') if reformat
  
  clean = (text[-1] != "\n")
  res = text.gsub(/(.{1,#{width-1}}\S)(\s+|$)/, "\\1\n")
  (clean)? res.chomp : res 
end

  
# same as word_wrap(...) but returns an array of lines
#
# @return an array of lines containing the rearranged text
def self.word_wrap_lines(*args)
  word_wrap(*args).split("\n")
end


# wrap two texts in two separate columms
#
# @param separator is a string of characters inserted at every line between the two collums, for example ' ' or ' | ' 
# @return an array of lines containing the merged and rearranged texts
def self.two_cols_word_wrap_lines(text_left, separator, text_right, 
      width_left, width_right, reformat:false)
  left = word_wrap_lines(text_left, width_left, reformat:reformat)
  right = word_wrap_lines(text_right, width_right, reformat:reformat)

  top = [left.size, right.size].max
  lines = []
  i = 0
  while i < top
    l_part = left[i] || ''
    r_part = right[i] || ''
    lines << "%-*s%s%s" % [width_left, l_part, separator, r_part] 
    i += 1
  end
  lines
end


# same as two_cols_word_wrap_lines(...) but returns a text
#
# @return text with line breaks inserted as necessary 
def self.two_cols_word_wrap(*args)
  two_cols_word_wrap_lines(*args).join("\n")
end



end  
