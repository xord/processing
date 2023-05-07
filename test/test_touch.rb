require_relative 'helper'


class TestTouch < Test::Unit::TestCase

  P = Processing

  def touch(id, x, y)
    P::Touch.new id, x, y
  end

  def test_inspect()
    assert_equal "#<Processing::Touch: id:1 x:2 y:3>", touch(1, 2, 3).inspect
  end

end# TestTouch
