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
      rect 100, 100, 500, 500
    END
  end

  def test_default_stroke_color()
    assert_draw <<~END, draw_header: ''
      background 100
      noFill
      strokeWeight 50
      line 100, 100, 500, 500
    END
  end

  def test_rect_fill()
    assert_draw                   'rect 100, 200, 300, 400'
    assert_draw 'rectMode CORNER;  rect 100, 200, 300, 400'
    assert_draw 'rectMode CORNERS; rect 100, 200, 300, 500'
    assert_draw 'rectMode CENTER;  rect 400, 500, 300, 400'
    assert_draw 'rectMode RADIUS;  rect 400, 500, 300, 400'
  end

  def test_rect_stroke()
    header = 'noFill; stroke 0, 255, 0; strokeWeight 50'
    assert_draw header,                   'rect 100, 200, 300, 400'
    assert_draw header, 'rectMode CORNER;  rect 100, 200, 300, 400'
    assert_draw header, 'rectMode CORNERS; rect 100, 200, 300, 500'
    assert_draw header, 'rectMode CENTER;  rect 400, 500, 300, 400'
    assert_draw header, 'rectMode RADIUS;  rect 400, 500, 300, 400'
  end

  def test_ellipse_fill()
    assert_draw                      'ellipse 400, 500, 300, 400'
    assert_draw 'ellipseMode CORNER;  ellipse 100, 200, 300, 400'
    assert_draw 'ellipseMode CORNERS; ellipse 100, 200, 300, 500'
    assert_draw 'ellipseMode CENTER;  ellipse 400, 500, 300, 400'
    assert_draw 'ellipseMode RADIUS;  ellipse 400, 500, 300, 400'
  end

  def test_ellipse_stroke()
    header = 'noFill; stroke 0, 255, 0; strokeWeight 50'
    assert_draw header,                      'ellipse 400, 500, 300, 400'
    assert_draw header, 'ellipseMode CORNER;  ellipse 100, 200, 300, 400'
    assert_draw header, 'ellipseMode CORNERS; ellipse 100, 200, 300, 500'
    assert_draw header, 'ellipseMode CENTER;  ellipse 400, 500, 300, 400'
    assert_draw header, 'ellipseMode RADIUS;  ellipse 400, 500, 300, 400'
  end

end# TestDraw
