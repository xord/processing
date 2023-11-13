require_relative 'helper'


class TestShape < Test::Unit::TestCase

  P = Processing
  G = P::GraphicsContext

  def shape(kind, *args, g: graphics)
    g.createShape kind, *args
  end

  def test_size()
    s = shape G::RECT, 100, 200, 300, 400
    assert_equal 300, s.width
    assert_equal 400, s.height
  end

  def test_visibility()
    gfx = graphics 100, 100 do |g|
      g.background 0
    end
    assert_equal 1, get_pixels(gfx).uniq.size

    gfx = graphics 100, 100 do |g|
      s = shape G::RECT, 10, 20, 30, 40, g: g
      assert_true s.isVisible
      assert_true s.visible?

      g.background 0
      g.fill 255
      g.noStroke
      g.shape s
    end
    assert_equal 2, get_pixels(gfx).uniq.size

    gfx = graphics 100, 100 do |g|
      s = shape G::RECT, 10, 20, 30, 40, g: g
      s.setVisible false
      assert_false s.isVisible
      assert_false s.visible?

      g.background 0
      g.fill 255
      g.noStroke
      g.shape s
    end
    assert_equal 1, get_pixels(gfx).uniq.size
  end

end# TestShape
