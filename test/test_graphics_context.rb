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

  def test_color()
    g = graphics

    g.colorMode G::RGB, 255
    c = g.color 10, 20, 30, 40
    assert_equal 0x280a141e, c
    assert_equal [10, 20, 30, 40], [g.red(c), g.green(c), g.blue(c), g.alpha(c)]

    g.colorMode G::RGB, 1.0
    c = g.color 0.1, 0.2, 0.3, 0.4
    assert_equal 0x6619334c, c
    assert_in_delta 0.1, g.red(c),   1 / 256.0
    assert_in_delta 0.2, g.green(c), 1 / 256.0
    assert_in_delta 0.3, g.blue(c),  1 / 256.0
    assert_in_delta 0.4, g.alpha(c), 1 / 256.0
  end

end# TestGraphics
