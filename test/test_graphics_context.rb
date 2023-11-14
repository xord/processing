require_relative 'helper'


class TestGraphicsContext < Test::Unit::TestCase

  P = Processing
  G = P::Graphics

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

  def test_clear()
    colors = -> g {get_pixels(g).map(&:to_a).flatten.uniq}

    g = graphics
    assert_equal     [0], colors[g]

    g.beginDraw {g.ellipse 0, 0, g.width, g.height}
    assert_not_equal [0], colors[g]

    g.beginDraw {g.clear}
    assert_equal     [0], colors[g]
  end

  def test_lerp()
    g = graphics

    assert_equal 1.0, g.lerp(1.0, 2.0, 0.0)
    assert_equal 1.5, g.lerp(1.0, 2.0, 0.5)
    assert_equal 2.0, g.lerp(1.0, 2.0, 1.0)

    assert_equal 0.9, g.lerp(1.0, 2.0, -0.1)
    assert_equal 2.1, g.lerp(1.0, 2.0,  1.1)
  end

  def test_lerpColor()
    g = graphics
    c = -> red, green, blue {g.color red, green, blue}

    assert_equal c[10, 20, 30], g.lerpColor(c[10, 20, 30], c[50, 60, 70], 0.0)
    assert_equal c[30, 40, 50], g.lerpColor(c[10, 20, 30], c[50, 60, 70], 0.5)
    assert_equal c[50, 60, 70], g.lerpColor(c[10, 20, 30], c[50, 60, 70], 1.0)

    assert_equal c[-10, 0,  10], g.lerpColor(c[10, 20, 30], c[50, 60, 70], -0.5)
    assert_equal c[ 70, 80, 90], g.lerpColor(c[10, 20, 30], c[50, 60, 70],  1.5)
  end

end# TestGraphicsContext
