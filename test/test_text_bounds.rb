require_relative 'helper'


class TestTextBounds < Test::Unit::TestCase

  P = Processing

  def bounds(*args)
    P::TextBounds.new(*args)
  end

  def test_inspect()
    assert_equal "#<Processing::TextBounds: x:1 y:2 w:3 h:4>", bounds(1, 2, 3, 4).inspect
  end

end# TestTextBounds
