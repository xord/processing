require_relative 'helper'


class TestGraphicsContext < Test::Unit::TestCase

  P = Processing
  G = P::Graphics

  def graphics(w = 10, h = 10)
    G.new w, h
  end

  def test_colorMode()
    g = graphics
    assert_equal G::RGB, g.colorMode

    g.colorMode G::HSB, 1
    assert_equal G::HSB, g.colorMode

    assert_raise {g.colorMode LEFT}
  end

  def test_angleMode()
    g = graphics
    assert_equal G::RADIANS, g.angleMode

    g.angleMode G::DEGREES
    assert_equal G::DEGREES, g.angleMode

    assert_raise {g.angleMode LEFT}
  end

  def test_blendMode()
    g = graphics
    assert_equal G::BLEND, g.blendMode

    g.blendMode G::ADD
    assert_equal G::ADD, g.blendMode

    assert_raise {g.blendMode LEFT}
  end

end# TestGraphics
