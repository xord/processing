require_relative 'helper'


class TestFont < Test::Unit::TestCase

  P = Processing

  def font()
    P::Font.new Rays::Font.new(nil, 10)
  end

  def test_inspect()
    assert_match %r|#<Processing::Font: name:'[\w\s]+' size:[\d\.]+>|, font.inspect
  end

end# TestFont
