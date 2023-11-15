require_relative 'helper'


class TestDraw < Test::Unit::TestCase

  THRESHOLD_TO_BE_FIXED = 0.0

  def test_default_background_color()
    assert_draw '', default_header: '', threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_default_fill_color()
    assert_draw <<~END, default_header: nil
      background 100
      noStroke
      rect 100, 100, 500, 500
    END
  end

  def test_default_stroke_color()
    assert_draw <<~END, default_header: nil
      background 100
      noFill
      strokeWeight 50
      line 100, 100, 500, 500
    END
  end

  def test_point()
    src = 'strokeWeight 300; point 500, 600'
    assert_fill        src
    assert_stroke      src, threshold: THRESHOLD_TO_BE_FIXED
    assert_fill_stroke src, threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_line()
    src = 'strokeWeight 100; line 100, 200, 500, 600'
    assert_fill        src
    assert_stroke      src
    assert_fill_stroke src
  end

  def test_rect()
    src = 'rect 100, 200, 300, 400'
    assert_fill        src
    assert_stroke      src
    assert_fill_stroke src
  end

  def test_ellipse()
    src = 'ellipse 500, 600, 300, 400'
    assert_fill        src
    assert_stroke      src
    assert_fill_stroke src
  end

  def test_circle()
    src = 'circle 500, 600, 300'
    assert_fill        src
    assert_stroke      src
    assert_fill_stroke src
  end

  def test_arc()
    src = 'arc 500, 600, 300, 400, PI * 0.25, PI * 0.75'
    assert_fill        src, threshold: THRESHOLD_TO_BE_FIXED
    assert_stroke      src, threshold: THRESHOLD_TO_BE_FIXED
    assert_fill_stroke src, threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_square()
    src = 'square 500, 600, 300'
    assert_fill        src
    assert_stroke      src
    assert_fill_stroke src
  end

  def test_triangle()
    src = 'triangle 100,100, 100,500, 500,200'
    assert_fill        src
    assert_stroke      src
    assert_fill_stroke src
  end

  def test_quad()
    src = 'quad 100,100, 100,500, 500,500, 600,100'
    assert_fill        src
    assert_stroke      src
    assert_fill_stroke src
  end

  def test_curve()
    src = 'curve 100,100, 100,500, 500,500, 600,100'
    assert_fill        src, threshold: 0
    assert_stroke      src, threshold: 0
    assert_fill_stroke src, threshold: 0
  end

  def test_bezier()
    src = 'curve 100,100, 100,500, 500,500, 600,100'
    assert_fill        src, threshold: 0
    assert_stroke      src, threshold: 0
    assert_fill_stroke src, threshold: 0
  end

  def test_rectMode()
    assert_draw 'rectMode CORNER;  rect 100, 200, 300, 400'
    assert_draw 'rectMode CORNERS; rect 100, 200, 300, 500'
    assert_draw 'rectMode CENTER;  rect 400, 500, 300, 400'
    assert_draw 'rectMode RADIUS;  rect 400, 500, 300, 400'
  end

  def test_ellipseMode_ellipse()
    assert_draw 'ellipseMode CORNER;  ellipse 100, 200, 300, 400'
    assert_draw 'ellipseMode CORNERS; ellipse 100, 200, 300, 500'
    assert_draw 'ellipseMode CENTER;  ellipse 400, 500, 300, 400'
    assert_draw 'ellipseMode RADIUS;  ellipse 400, 500, 300, 400'
  end

  def test_ellipseMode_circle()
    assert_draw 'ellipseMode CORNER;  circle 100, 200, 300'
    assert_draw 'ellipseMode CORNERS; circle 100, 200, 300'
    assert_draw 'ellipseMode CENTER;  circle 400, 500, 300'
    assert_draw 'ellipseMode RADIUS;  circle 400, 500, 300'
  end

  def test_ellipseMode_arc()
    assert_draw 'ellipseMode CORNER;  arc 100, 200, 300, 400, 0, PI * 0.75',
      threshold: THRESHOLD_TO_BE_FIXED
    assert_draw 'ellipseMode CORNERS; arc 100, 200, 300, 500, 0, PI * 0.75',
      threshold: THRESHOLD_TO_BE_FIXED
    assert_draw 'ellipseMode CENTER;  arc 400, 500, 300, 400, 0, PI * 0.75',
      threshold: THRESHOLD_TO_BE_FIXED
    assert_draw 'ellipseMode RADIUS;  arc 400, 500, 300, 400, 0, PI * 0.75',
      threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_shapeMode_corner()
    header = 'noStroke'

    assert_draw_equal header, <<~EXPECTED, <<~ACTUAL
      rect 100, 200, 300, 400
    EXPECTED
      shapeMode CORNER
      shape createShape(RECT, 100, 200, 300, 400)
    ACTUAL

    assert_draw_equal header, <<~EXPECTED, <<~ACTUAL
      rect 100, 200, 300, 400
    EXPECTED
      shapeMode CORNER
      shape createShape(RECT, 0, 0, 300, 400), 100, 200
    ACTUAL

    assert_draw_equal header, <<~EXPECTED, <<~ACTUAL
      rect 100, 200, 300, 400
    EXPECTED
      shapeMode CORNER
      shape createShape(RECT, 0, 0, 500, 600), 100, 200, 300, 400
    ACTUAL
  end

  def test_shapeMode_corners()
    header = 'noStroke'

    assert_draw_equal header, <<~EXPECTED, <<~ACTUAL
      rect 100, 200, 300, 400
    EXPECTED
      shapeMode CORNERS
      shape createShape(RECT, 100, 200, 300, 400)
    ACTUAL

    assert_draw_equal header, <<~EXPECTED, <<~ACTUAL
      rect 100, 200, 200, 200
    EXPECTED
      shapeMode CORNERS
      shape createShape(RECT, 0, 0, 300, 400), 100, 200
    ACTUAL

    assert_draw_equal header, <<~EXPECTED, <<~ACTUAL
      rect 100, 200, 200, 200
    EXPECTED
      shapeMode CORNERS
      shape createShape(RECT, 0, 0, 500, 600), 100, 200, 300, 400
    ACTUAL
  end

  def test_shapeMode_center()
    header = 'noStroke'

    assert_draw_equal header, <<~EXPECTED, <<~ACTUAL
      rect 400, 400, 200, 400
    EXPECTED
      shapeMode CENTER
      shape createShape(RECT, 500, 600, 200, 400)
    ACTUAL

    assert_draw_equal header, <<~EXPECTED, <<~ACTUAL
      rect 400, 400, 200, 400
    EXPECTED
      shapeMode CENTER
      shape createShape(RECT, 0, 0, 200, 400), 500, 600
    ACTUAL

    assert_draw_equal header, <<~EXPECTED, <<~ACTUAL
      rect 400, 400, 200, 400
    EXPECTED
      shapeMode CENTER
      shape createShape(RECT, 0, 0, 700, 800), 500, 600, 200, 400
    ACTUAL
  end

end# TestDraw
