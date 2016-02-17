module Miniparse
  
  ####### UTILITY GENERAL FUNCTIONS

  def Miniparse.word_wrap(s, width, rewrap: false)
    s = s.gsub(/\s*\n/, ' ') if rewrap
    s.gsub(/(.{1,#{width-1}}\S(\s+|\Z))\s*/, "\\1\n")
  end

  def Miniparse.word_wrap_lines(*args)
    word_wrap(*args).split("\n")
  end

  def Miniparse.two_cols_word_wrap_lines(s_left, separator, s_right, 
        width_left, width_right)
    left = word_wrap_lines(s_left, width_left)
    right = word_wrap_lines(s_right, width_right)

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

  def Miniparse.two_cols_word_wrap(*args)
    two_cols_word_wrap_lines(*args).join("\n")
  end

end
