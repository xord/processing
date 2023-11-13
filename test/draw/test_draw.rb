require_relative 'helper'


class TestDraw < Test::Unit::TestCase

  THRESHOLD_TO_BE_FIXED = 0.0

  def test_default_background_color()
    assert_draw '', source_header: '', threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_default_fill_color()
    assert_draw <<~END, source_header: nil
      background 100
      noStroke
      rect 100, 100, 500, 500
    END
  end

  def test_default_stroke_color()
    assert_draw <<~END, source_header: nil
      background 100
      noFill
      strokeWeight 50
      line 100, 100, 500, 500
    END
  end

  def test_rect()
    assert_fill        'rect 100, 200, 300, 400'
    assert_stroke      'rect 100, 200, 300, 400'
    assert_fill_stroke 'rect 100, 200, 300, 400'

    assert_draw 'rectMode CORNER;  rect 100, 200, 300, 400'
    assert_draw 'rectMode CORNERS; rect 100, 200, 300, 500'
    assert_draw 'rectMode CENTER;  rect 400, 500, 300, 400'
    assert_draw 'rectMode RADIUS;  rect 400, 500, 300, 400'
  end

  def test_ellipse()
    assert_fill        'ellipse 400, 500, 300, 400'
    assert_stroke      'ellipse 400, 500, 300, 400'
    assert_fill_stroke 'ellipse 400, 500, 300, 400'

    assert_draw 'ellipseMode CORNER;  ellipse 100, 200, 300, 400'
    assert_draw 'ellipseMode CORNERS; ellipse 100, 200, 300, 500'
    assert_draw 'ellipseMode CENTER;  ellipse 400, 500, 300, 400'
    assert_draw 'ellipseMode RADIUS;  ellipse 400, 500, 300, 400'
  end

end# TestDraw
