require_relative 'helper'


class TestDraw < Test::Unit::TestCase

  def test_rect()
    assert_draw                   'rect 10, 20, 30, 40'
    assert_draw 'rectMode CORNER;  rect 10, 20, 30, 40'
    assert_draw 'rectMode CORNERS; rect 10, 20, 30, 50'
    assert_draw 'rectMode CENTER;  rect 40, 50, 30, 40'
    assert_draw 'rectMode RADIUS;  rect 40, 50, 30, 40'
  end

  def test_ellipse()
    assert_draw                      'ellipse 40, 50, 30, 40'
    assert_draw 'ellipseMode CORNER;  ellipse 10, 20, 30, 40'
    assert_draw 'ellipseMode CORNERS; ellipse 10, 20, 30, 50'
    assert_draw 'ellipseMode CENTER;  ellipse 40, 50, 30, 40'
    assert_draw 'ellipseMode RADIUS;  ellipse 40, 50, 30, 40'
  end

end# TestDraw
