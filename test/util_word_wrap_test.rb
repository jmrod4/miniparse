require 'test_helper'

class UtilTest < Minitest::Test

  def test_word_wrap
    text = "En un lugar de la mancha,\nde cuyo nombre no quiero acordarme."
    result = "\
En un lugar de la
mancha,
de cuyo nombre no
quiero acordarme."

    assert_equal(result, WordWrap.word_wrap(text, 20))
    assert_equal(result+"\n", WordWrap.word_wrap(text+"\n", 20))
    assert_equal("\n"+result, WordWrap.word_wrap("\n"+text, 20))
    
    result = "\
En un lugar de la
mancha, de cuyo
nombre no quiero
acordarme."

    assert_equal(result, WordWrap.word_wrap(text, 20, reformat:true))
    
    result2 = "\
En un lugar de la   |En un lugar de la
mancha,             |mancha,
de cuyo nombre no   |de cuyo nombre no
quiero acordarme.   |quiero acordarme."

    assert_equal(result2, 
        WordWrap.two_cols_word_wrap(text, '|', text, 20, 20))
        
    result2 = "\
En un lugar de la   | En un lugar de la
mancha, de cuyo     | mancha, de cuyo
nombre no quiero    | nombre no quiero
acordarme.          | acordarme."

    assert_equal(result2, 
        WordWrap.two_cols_word_wrap(text, '| ', text, 20, 20, reformat:true))
  end

end
