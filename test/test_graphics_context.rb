require_relative 'helper'


class TestGraphicsContext < Test::Unit::TestCase

  P = Processing
  G = P::Graphics

  THRESHOLD_TO_BE_FIXED = 0.0

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

  def test_default_background_color()
    assert_p5_draw '', default_header: '', threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_default_fill_color()
    assert_p5_draw <<~END, default_header: nil
      background 100
      noStroke
      rect 100, 100, 500, 500
    END
  end

  def test_default_stroke_color()
    assert_p5_draw <<~END, default_header: nil
      background 100
      noFill
      strokeWeight 50
      line 100, 100, 500, 500
    END
  end

  def test_clear()
    colors = -> g {get_pixels(g).uniq}

    g = graphics
    assert_equal     [0], colors[g]

    g.beginDraw {g.ellipse 0, 0, g.width, g.height}
    assert_not_equal [0], colors[g]

    g.beginDraw {g.clear}
    assert_equal     [0], colors[g]
  end

  def test_point()
    src = 'strokeWeight 300; point 500, 600'
    assert_p5_fill        src
    assert_p5_stroke      src, threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_fill_stroke src, threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_line()
    src = 'strokeWeight 100; line 100, 200, 500, 600'
    assert_p5_fill        src
    assert_p5_stroke      src
    assert_p5_fill_stroke src
  end

  def test_rect()
    src = 'rect 100, 200, 300, 400'
    assert_p5_fill        src
    assert_p5_stroke      src
    assert_p5_fill_stroke src
  end

  def test_rect_with_rectMode()
    assert_p5_draw 'rectMode CORNER;  rect 100, 200, 300, 400'
    assert_p5_draw 'rectMode CORNERS; rect 100, 200, 300, 500'
    assert_p5_draw 'rectMode CENTER;  rect 400, 500, 300, 400'
    assert_p5_draw 'rectMode RADIUS;  rect 400, 500, 300, 400'
  end

  def test_ellipse()
    src = 'ellipse 500, 600, 300, 400'
    assert_p5_fill        src
    assert_p5_stroke      src
    assert_p5_fill_stroke src
  end

  def test_ellipse_with_ellipseMode()
    assert_p5_draw 'ellipseMode CORNER;  ellipse 100, 200, 300, 400'
    assert_p5_draw 'ellipseMode CORNERS; ellipse 100, 200, 300, 500'
    assert_p5_draw 'ellipseMode CENTER;  ellipse 400, 500, 300, 400'
    assert_p5_draw 'ellipseMode RADIUS;  ellipse 400, 500, 300, 400'
  end

  def test_circle()
    src = 'circle 500, 600, 300'
    assert_p5_fill        src
    assert_p5_stroke      src
    assert_p5_fill_stroke src
  end

  def test_circle_with_ellipseMode()
    assert_p5_draw 'ellipseMode CORNER;  circle 100, 200, 300'
    assert_p5_draw 'ellipseMode CORNERS; circle 100, 200, 300'
    assert_p5_draw 'ellipseMode CENTER;  circle 400, 500, 300'
    assert_p5_draw 'ellipseMode RADIUS;  circle 400, 500, 300'
  end

  def test_arc()
    src = 'arc 500, 600, 300, 400, PI * 0.25, PI * 0.75'
    assert_p5_fill        src, threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_stroke      src, threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_fill_stroke src, threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_arc_with_ellipseMode()
    assert_p5_draw 'ellipseMode CORNER;  arc 100, 200, 300, 400, 0, PI * 0.75',
      threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_draw 'ellipseMode CORNERS; arc 100, 200, 300, 500, 0, PI * 0.75',
      threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_draw 'ellipseMode CENTER;  arc 400, 500, 300, 400, 0, PI * 0.75',
      threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_draw 'ellipseMode RADIUS;  arc 400, 500, 300, 400, 0, PI * 0.75',
      threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_square()
    src = 'square 500, 600, 300'
    assert_p5_fill        src
    assert_p5_stroke      src
    assert_p5_fill_stroke src
  end

  def test_triangle()
    src = 'triangle 100,100, 100,500, 500,200'
    assert_p5_fill        src
    assert_p5_stroke      src
    assert_p5_fill_stroke src
  end

  def test_quad()
    src = 'quad 100,100, 100,500, 500,500, 600,100'
    assert_p5_fill        src
    assert_p5_stroke      src
    assert_p5_fill_stroke src
  end

  def test_curve()
    src = 'curve 100,100, 100,500, 500,500, 600,100'
    assert_p5_fill        src, threshold: 0
    assert_p5_stroke      src, threshold: 0
    assert_p5_fill_stroke src, threshold: 0
  end

  def test_bezier()
    src = 'curve 100,100, 100,500, 500,500, 600,100'
    assert_p5_fill        src, threshold: 0
    assert_p5_stroke      src, threshold: 0
    assert_p5_fill_stroke src, threshold: 0
  end

  def test_shape_with_shapeMode_corner()
    header = 'noStroke'

    assert_equal_draw header, <<~EXPECTED, <<~ACTUAL
      rect 100, 200, 300, 400
    EXPECTED
      shapeMode CORNER
      shape createShape(RECT, 100, 200, 300, 400)
    ACTUAL

    assert_equal_draw header, <<~EXPECTED, <<~ACTUAL
      rect 100, 200, 300, 400
    EXPECTED
      shapeMode CORNER
      shape createShape(RECT, 0, 0, 300, 400), 100, 200
    ACTUAL

    assert_equal_draw header, <<~EXPECTED, <<~ACTUAL
      rect 100, 200, 300, 400
    EXPECTED
      shapeMode CORNER
      shape createShape(RECT, 0, 0, 500, 600), 100, 200, 300, 400
    ACTUAL
  end

  def test_shape_with_shapeMode_corners()
    header = 'noStroke'

    assert_equal_draw header, <<~EXPECTED, <<~ACTUAL
      rect 100, 200, 300, 400
    EXPECTED
      shapeMode CORNERS
      shape createShape(RECT, 100, 200, 300, 400)
    ACTUAL

    assert_equal_draw header, <<~EXPECTED, <<~ACTUAL
      rect 100, 200, 200, 200
    EXPECTED
      shapeMode CORNERS
      shape createShape(RECT, 0, 0, 300, 400), 100, 200
    ACTUAL

    assert_equal_draw header, <<~EXPECTED, <<~ACTUAL
      rect 100, 200, 200, 200
    EXPECTED
      shapeMode CORNERS
      shape createShape(RECT, 0, 0, 500, 600), 100, 200, 300, 400
    ACTUAL
  end

  def test_shape_with_shapeMode_center()
    header = 'noStroke'

    assert_equal_draw header, <<~EXPECTED, <<~ACTUAL
      rect 400, 400, 200, 400
    EXPECTED
      shapeMode CENTER
      shape createShape(RECT, 500, 600, 200, 400)
    ACTUAL

    assert_equal_draw header, <<~EXPECTED, <<~ACTUAL
      rect 400, 400, 200, 400
    EXPECTED
      shapeMode CENTER
      shape createShape(RECT, 0, 0, 200, 400), 500, 600
    ACTUAL

    assert_equal_draw header, <<~EXPECTED, <<~ACTUAL
      rect 400, 400, 200, 400
    EXPECTED
      shapeMode CENTER
      shape createShape(RECT, 0, 0, 700, 800), 500, 600, 200, 400
    ACTUAL
  end

  def test_shape_with_groups()
    assert_equal_draw <<~EXPECTED, <<~ACTUAL
      rect 100, 100, 300, 200
      rect 200, 200, 300, 200
    EXPECTED
      group = createShape GROUP
      group.addChild createShape(RECT, 100, 100, 300, 200)
      group.addChild createShape(RECT, 200, 200, 300, 200)
      shape group
    ACTUAL

    assert_equal_draw <<~EXPECTED, <<~ACTUAL
      rect 100, 100, 300, 200
      rect 200, 200, 300, 200
    EXPECTED
      group1 = createShape GROUP
      group2 = createShape GROUP
      group1.addChild createShape(RECT, 100, 100, 300, 200)
      group1.addChild group2
      group2.addChild createShape(RECT, 200, 200, 300, 200)
      shape group1
    ACTUAL
  end

  def test_shape_with_non_groups()
    assert_equal_draw '', <<~ACTUAL
      s = createShape
      s.addChild createShape(RECT, 100, 100, 300, 200)
      s.addChild createShape(RECT, 200, 200, 300, 200)
      shape s
    ACTUAL
  end

  def test_beginShape_points()
    src = <<~END
      strokeWeight 200
      beginShape POINTS
      vertex 200, 300
      vertex 500, 600
    END
    assert_p5_fill        src, 'endShape'
    assert_p5_stroke      src, 'endShape', threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_fill_stroke src, 'endShape', threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_beginShape_lines()
    src = <<~END
      strokeWeight 200
      beginShape LINES
      vertex 100, 200
      vertex 300, 400
      vertex 500, 600
      vertex 700, 800
    END
    assert_p5_fill        src, 'endShape'
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape'
    assert_p5_fill        src, 'endShape CLOSE'
    assert_p5_stroke      src, 'endShape CLOSE'
    assert_p5_fill_stroke src, 'endShape CLOSE'
  end

  def test_beginShape_triangles()
    src = <<~END
      beginShape TRIANGLES
      vertex 100, 100
      vertex 100, 500
      vertex 400, 200
      vertex 500, 100
      vertex 500, 500
      vertex 900, 200
    END
    assert_p5_fill        src, 'endShape'
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape'
    assert_p5_fill        src, 'endShape CLOSE'
    assert_p5_stroke      src, 'endShape CLOSE'
    assert_p5_fill_stroke src, 'endShape CLOSE'
  end

  def test_beginShape_triangle_fan()
    src = <<~END
      beginShape TRIANGLE_FAN
      vertex 100, 100
      vertex 100, 500
      vertex 200, 600
      vertex 300, 500
      vertex 400, 600
      vertex 500, 200
      vertex 400, 100
    END
    assert_p5_fill        src, 'endShape'
    assert_p5_stroke      src, 'endShape', threshold: 0.98
    assert_p5_fill_stroke src, 'endShape', threshold: 0.98
    assert_p5_fill        src, 'endShape CLOSE'
    assert_p5_stroke      src, 'endShape CLOSE', threshold: 0.98
    assert_p5_fill_stroke src, 'endShape CLOSE', threshold: 0.98
  end

  def test_beginShape_triangle_strip()
    src = <<~END
      beginShape TRIANGLE_STRIP
      vertex 100, 100
      vertex 100, 900
      vertex 500, 200
      vertex 500, 800
      vertex 900, 100
      vertex 900, 900
    END
    assert_p5_fill        src, 'endShape'
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape'
    assert_p5_fill        src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_stroke      src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_fill_stroke src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_beginShape_quads()
    src = <<~END
      beginShape QUADS
      vertex 100, 100
      vertex 200, 500
      vertex 300, 400
      vertex 400, 200
      vertex 500, 100
      vertex 600, 500
      vertex 700, 400
      vertex 800, 200
    END
    assert_p5_fill        src, 'endShape'
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape'
    assert_p5_fill        src, 'endShape CLOSE'
    assert_p5_stroke      src, 'endShape CLOSE'
    assert_p5_fill_stroke src, 'endShape CLOSE'
  end

  def test_beginShape_quad_strip()
    src = <<~END
      beginShape QUAD_STRIP
      vertex 100, 100
      vertex 100, 500
      vertex 500, 200
      vertex 500, 400
      vertex 900, 100
      vertex 900, 500
    END
    assert_p5_fill        src, 'endShape'
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape'
    assert_p5_fill        src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_stroke      src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_fill_stroke src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_beginShape_tess()
    src = <<~END
      beginShape TESS
      vertex 100, 100
      vertex 100, 500
      vertex 500, 500
      vertex 500, 400
      vertex 300, 400
      vertex 300, 300
      vertex 500, 300
      vertex 500, 100
    END
    assert_p5_fill        src, 'endShape'
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape'
    assert_p5_fill        src, 'endShape CLOSE'
    assert_p5_stroke      src, 'endShape CLOSE'
    assert_p5_fill_stroke src, 'endShape CLOSE'
  end

  def test_beginShape_polygon()
    src = <<~END
      beginShape
      vertex 100, 100
      vertex 100, 500
      vertex 500, 500
      vertex 500, 400
      vertex 300, 400
      vertex 300, 300
      vertex 500, 300
      vertex 500, 100
    END
    assert_p5_fill        src, 'endShape'
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape'
    assert_p5_fill        src, 'endShape CLOSE'
    assert_p5_stroke      src, 'endShape CLOSE'
    assert_p5_fill_stroke src, 'endShape CLOSE'
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

  def test_createShape_line()
    assert_equal_draw <<~EXPECTED, <<~ACTUAL
      line 100, 200, 800, 900
    EXPECTED
      shape createShape(LINE, 100, 200, 800, 900)
    ACTUAL
  end

  def test_createShape_rect()
    assert_equal_draw <<~EXPECTED, <<~ACTUAL
      rect 100, 200, 500, 600
    EXPECTED
      shape createShape(RECT, 100, 200, 500, 600)
    ACTUAL
  end

  def test_createShape_ellipse()
    assert_equal_draw <<~EXPECTED, <<~ACTUAL
      ellipse 500, 600, 300, 400
    EXPECTED
      shape createShape(ELLIPSE, 500, 600, 300, 400)
    ACTUAL
  end

  def test_createShape_arc()
    assert_equal_draw <<~EXPECTED, <<~ACTUAL
      arc 500, 600, 300, 400, 0, PI / 2
    EXPECTED
      shape createShape(ARC, 500, 600, 300, 400, 0, PI / 2)
    ACTUAL
  end

  def test_createShape_triangle()
    assert_equal_draw <<~EXPECTED, <<~ACTUAL
      triangle 100,100, 100,500, 400,200
    EXPECTED
      shape createShape(TRIANGLE, 100,100, 100,500, 400,200)
    ACTUAL
  end

  def test_createShape_quad()
    assert_equal_draw <<~EXPECTED, <<~ACTUAL
      quad 100,100, 100,500, 500,500, 600,100
    EXPECTED
      shape createShape(QUAD, 100,100, 100,500, 500,500, 600,100)
    ACTUAL
  end

end# TestGraphicsContext
