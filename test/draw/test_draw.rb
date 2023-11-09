require_relative 'helper'


class TestDraw < Test::Unit::TestCase

  THRESHOLD_TO_BE_FIXED = 0.0

  def test_default_background_color()
    assert_draw '', draw_header: '', threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_default_fill_color()
    assert_draw <<~END, draw_header: ''
      background 100
      noStroke
      rect 10, 10, 50, 50
    END
  end

  def test_default_stroke_color()
    assert_draw <<~END, draw_header: ''
      background 100
      noFill
      strokeWeight 10
      line 10, 10, 50, 50
    END
  end

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
