require_relative 'helper'


class TestDraw < Test::Unit::TestCase

  def test_rect()
    assert_draw 100, 100,                   'rect 10, 10, 50, 50'
    assert_draw 100, 100, 'rectMode CORNER;  rect 10, 10, 50, 50'
    assert_draw 100, 100, 'rectMode CORNERS; rect 10, 10, 50, 50'
    assert_draw 100, 100, 'rectMode CENTER;  rect 10, 10, 50, 50'
    assert_draw 100, 100, 'rectMode RADIUS;  rect 10, 10, 50, 50'
  end

  def test_ellipse()
    assert_draw 100, 100,                      'ellipse 10, 10, 50, 50', threshold: 0.98
    assert_draw 100, 100, 'ellipseMode CORNER;  ellipse 10, 10, 50, 50', threshold: 0.98
    assert_draw 100, 100, 'ellipseMode CORNERS; ellipse 10, 10, 50, 50', threshold: 0.98
    assert_draw 100, 100, 'ellipseMode CENTER;  ellipse 10, 10, 50, 50', threshold: 0.98
    assert_draw 100, 100, 'ellipseMode RADIUS;  ellipse 10, 10, 50, 50', threshold: 0.98
  end

end# TestDraw
