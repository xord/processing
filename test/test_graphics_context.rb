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

  def test_textFont()
    graphics do |g|
      arial10     = g.createFont 'Arial',     10
      helvetica11 = g.createFont 'Helvetica', 11

      font        = -> {g.instance_variable_get(:@textFont__).getInternal__}
      painterFont = -> {g.instance_variable_get(:@painter__).font}

      assert_not_nil            font[]       .name
      assert_not_equal 'Arial', font[]       .name
      assert_equal     12,      font[]       .size
      assert_equal     12,      painterFont[].size

      g.textFont arial10
      assert_equal 'Arial', font[]       .name
      assert_equal 10,      font[]       .size
      assert_equal 10,      painterFont[].size

      g.push do
        g.textFont helvetica11
        assert_equal 'Helvetica', font[]       .name
        assert_equal 11,          font[]       .size
        assert_equal 11,          painterFont[].size
      end

      assert_equal 'Arial', font[]       .name
      assert_equal 10,      font[]       .size
      assert_equal 10,      painterFont[].size

      g.push do
        g.textFont arial10, 13
        assert_equal 'Arial', font[]       .name
        assert_equal 13,      font[]       .size
        assert_equal 13,      painterFont[].size
      end

      assert_equal 'Arial', font[]       .name
      assert_equal 10,      font[]       .size
      assert_equal 10,      painterFont[].size
    end
  end

  def test_textSize()
    graphics do |g|
      font        = -> {g.instance_variable_get(:@textFont__).getInternal__}
      painterFont = -> {g.instance_variable_get(:@painter__).font}

      assert_equal 12, font[]       .size
      assert_equal 12, painterFont[].size

      g.push do
        g.textSize 10
        assert_equal 10, font[]       .size
        assert_equal 10, painterFont[].size
      end

      assert_equal 12, font[]       .size
      assert_equal 12, painterFont[].size
    end
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
    assert_p5_fill        src, threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_stroke      src
    assert_p5_fill_stroke src
  end

  def test_bezier()
    src = 'bezier 100,100, 100,500, 500,500, 600,100'
    assert_p5_fill        src
    assert_p5_stroke      src
    assert_p5_fill_stroke src
  end

  def test_curveDetail()
    opts = {
      webgl: true,
      # tests in headless mode will time out...
      headless: false,
      # Something is wrong with the behavior of `p5.js + WEBGL + curve()`
      threshold: THRESHOLD_TO_BE_FIXED
    }
    [1, 2, 3, 5, 10, 100].each do |detail|
      assert_p5_stroke <<~END, label: test_label(2, suffix: detail), **opts
        curveDetail #{detail}
        curve 100,100, 100,500, 500,500, 600,100
       END
    end
  end

  def test_bezierDetail()
    opts = {webgl: true, headless: false} # tests in headless mode will time out...
    [1, 2, 3, 5, 10, 100].each do |detail|
      assert_p5_stroke <<~END, label: test_label(2, suffix: detail), **opts
        bezierDetail #{detail}
        bezier 100,100, 100,500, 500,500, 600,100
      END
    end
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

  def test_beginShape_with_fill()
    assert_equal_draw <<~HEADER, <<~EXPECTED, <<~ACTUAL
      noStroke
    HEADER
      fill 0, 255, 0
      rect 100, 100, 500, 400
    EXPECTED
      beginShape
      fill 0, 255, 0
      vertex 100, 100
      vertex 600, 100
      vertex 600, 500
      vertex 100, 500
      endShape
    ACTUAL
  end

  def test_curveVertex()
    src = <<~END
      beginShape
      curveVertex 100, 100
      curveVertex 800, 100
      curveVertex 800, 800
      curveVertex 100, 800
    END
    assert_p5_fill        src, 'endShape'
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape'
    assert_p5_fill        src, 'endShape CLOSE'
    assert_p5_stroke      src, 'endShape CLOSE'
    assert_p5_fill_stroke src, 'endShape CLOSE'

    src = <<~END
      beginShape
      curveVertex 200, 200
      curveVertex 200, 200
      curveVertex 800, 200
      curveVertex 800, 400
      curveVertex 200, 400
      curveVertex 200, 800
      curveVertex 800, 800
      curveVertex 800, 700
      curveVertex 800, 700
    END
    assert_p5_fill        src, 'endShape',       threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape',       threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_fill        src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_stroke      src, 'endShape CLOSE'
    assert_p5_fill_stroke src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_bezierVertex()
    src = <<~END
      beginShape
      vertex 100, 100
      bezierVertex 900, 100, 900, 900, 200, 500
    END
    assert_p5_fill        src, 'endShape'
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape'
    assert_p5_fill        src, 'endShape CLOSE'
    assert_p5_stroke      src, 'endShape CLOSE'
    assert_p5_fill_stroke src, 'endShape CLOSE'

    src = <<~END
      beginShape
      vertex 100, 100
      bezierVertex 900, 100, 900, 500, 300, 500
      bezierVertex 100, 900, 900, 900, 900, 600
    END
    assert_p5_fill        src, 'endShape',       threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape',       threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_fill        src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_stroke      src, 'endShape CLOSE'
    assert_p5_fill_stroke src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_quadraticVertex()
    src = <<~END
      beginShape
      vertex 100, 100
      quadraticVertex 800, 500, 200, 800
    END
    assert_p5_fill        src, 'endShape'
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape'
    assert_p5_fill        src, 'endShape CLOSE'
    assert_p5_stroke      src, 'endShape CLOSE'
    assert_p5_fill_stroke src, 'endShape CLOSE'

    src = <<~END
      beginShape
      vertex 100, 100
      quadraticVertex 800, 100, 500, 500
      quadraticVertex 100, 800, 800, 800
    END
    assert_p5_fill        src, 'endShape',       threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape',       threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_fill        src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
    assert_p5_stroke      src, 'endShape CLOSE'
    assert_p5_fill_stroke src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
  end

  def test_contour()
    src = <<~END
      beginShape
      vertex 100, 100
      vertex 100, 900
      vertex 900, 900
      vertex 900, 100
      beginContour
      vertex 200, 200
      vertex 800, 200
      vertex 700, 700
      vertex 200, 800
      endContour
    END
    assert_p5_fill        src, 'endShape'
    assert_p5_stroke      src, 'endShape'
    assert_p5_fill_stroke src, 'endShape'
    assert_p5_fill        src, 'endShape CLOSE'
    assert_p5_stroke      src, 'endShape CLOSE'
    assert_p5_fill_stroke src, 'endShape CLOSE'
  end

  def test_pixels()
    g = graphics 2, 2

    g.loadPixels
    assert_equal [0] * 4, g.pixels
    assert_equal [0] * 4, g.getInternal__.pixels

    g.pixels.replace [0xffff0000, 0xff00ff00, 0xff0000ff, 0xff000000]
    assert_equal [0xffff0000, 0xff00ff00, 0xff0000ff, 0xff000000], g.pixels
    assert_equal [0] * 4,                                          g.getInternal__.pixels

    g.updatePixels
    assert_nil                                                     g.pixels
    assert_equal [0xffff0000, 0xff00ff00, 0xff0000ff, 0xff000000], g.getInternal__.pixels
    assert_nothing_raised {g.updatePixels}

    g.loadPixels
    g.pixels.replace [0xff000000]
    assert_raise(ArgumentError) {g.updatePixels}
  end

  def test_pixels_and_modified_flags()
    drawRect     = -> g, x, *rgb do
      g.beginDraw do
        g.fill(*rgb)
        g.rect x, 0, 2, 2
      end
    end
    updatePixels = -> g, i, *rgb do
      g.loadPixels
      g.pixels[i] = g.color(*rgb)
      g.updatePixels
    end
    getPixels    = -> g do
      g.getInternal__.pixels
        .select.with_index {|_, i| i.even?}
        .map {|n| n.to_s 16}
    end

    g = graphics 6, 1
    drawRect    .call g, 0, 255,0,0
    assert_equal %w[ffff0000 0        0],        getPixels.call(g)

    g = graphics 6, 1
    drawRect    .call g, 0, 255,0,0
    updatePixels.call g, 2, 0,255,0
    assert_equal %w[ffff0000 ff00ff00 0],        getPixels.call(g)

    g = graphics 6, 1
    drawRect    .call g, 0, 255,0,0
    updatePixels.call g, 2, 0,255,0
    drawRect    .call g, 4, 0,0,255
    assert_equal %w[ffff0000 ff00ff00 ff0000ff], getPixels.call(g)
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

  def test_createFont()
    g = graphics

    assert_not_nil        g.createFont(nil,     nil).getInternal__.name
    assert_equal 'Arial', g.createFont('Arial', nil).getInternal__.name

    assert_equal 12, g.createFont(nil, nil).getInternal__.size
    assert_equal 10, g.createFont(nil, 10) .getInternal__.size
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

  def test_curvePoint()
    assert_p5_draw <<~END
      steps = 8
      (0..steps).each do |i|
        t = i.to_f / steps.to_f;
        x = curvePoint(*[20,  20,  292, 292].map {|n| n * 3}, t)
        y = curvePoint(*[104, 104, 96,  244].map {|n| n * 3}, t)
        point x, y
        x = curvePoint(*[20,  292, 292, 60] .map {|n| n * 3}, t)
        y = curvePoint(*[104, 96,  244, 260].map {|n| n * 3}, t)
        point x, y
      end
    END
  end

  def test_bezierPoint()
    assert_p5_draw <<~END
      steps = 10
      (0..steps).each do |i|
        t = i.to_f / steps.to_f
        x = bezierPoint(*[85, 10, 90, 15].map {|n| n * 10}, t)
        y = bezierPoint(*[20, 10, 90, 80].map {|n| n * 10}, t)
        point x, y
      end
    END
  end

  def test_curveTangent()
    assert_p5_draw <<~END
      drawTangent = -> x, y, tx, ty do
        tv = createVector tx, ty
        tv.normalize
        tv.rotate radians(-90)
        point x, y
        push
        stroke 0, 0, 255
        strokeWeight 20
        line x, y, x + tv.x * 100, y + tv.y * 100
        pop
      end
      steps = 8
      (0..steps).each do |i|
        t = i.to_f / steps.to_f;

        xx = [20,  20,  292, 292].map {|n| n * 2}
        yy = [104, 104, 96,  244].map {|n| n * 3}
        x  = curvePoint(  *xx, t)
        y  = curvePoint(  *yy, t)
        tx = curveTangent(*xx, t)
        ty = curveTangent(*yy, t)
        drawTangent.call x, y, tx, ty

        xx = [20,  292, 292, 60] .map {|n| n * 2}
        yy = [104, 96,  244, 260].map {|n| n * 3}
        x  = curvePoint(  *xx, t)
        y  = curvePoint(  *yy, t)
        tx = curveTangent(*xx, t)
        ty = curveTangent(*yy, t)
        drawTangent.call x, y, tx, ty
      end
    END
  end

  def test_bezierTangent()
    assert_p5_draw <<~END
      drawTangent = -> x, y, tx, ty do
        tv = createVector tx, ty
        tv.normalize
        tv.rotate radians(-90)
        point x, y
        push
        stroke 0, 0, 255
        strokeWeight 20
        line x, y, x + tv.x * 100, y + tv.y * 100
        pop
      end
      steps = 10
      (0..steps).each do |i|
        t = i.to_f / steps.to_f

        xx = *[85, 10, 90, 15].map {|n| n * 10}
        yy = *[20, 10, 90, 80].map {|n| n * 10}
        x  = bezierPoint(  *xx, t)
        y  = bezierPoint(  *yy, t)
        tx = bezierTangent(*xx, t)
        ty = bezierTangent(*yy, t)
        drawTangent.call x, y, tx, ty
      end
    END
  end

  def test_random()
    g = graphics

    assert_equal Float, g.random()        .class
    assert_equal Float, g.random(1)       .class
    assert_equal Float, g.random(1.0)     .class
    assert_equal Float, g.random(1,   2)  .class
    assert_equal Float, g.random(1.0, 2.0).class

    assert_not_equal g.random(1.0), g.random(1.0)

    assert_raise(ArgumentError) {g.random 0}
    assert_raise(ArgumentError) {g.random 1, 1}

    array = 10000.times.map {g.random 1, 2}
    assert array.all? {|n| (1.0...2.0).include? n}
    assert_in_delta 1.5, array.sum.to_f / array.size, 0.01
  end

  def test_random_choice()
    g = graphics

    assert_equal :a,  g.random([:a])
    assert_equal :a,  g.random([:a, :a])
    assert_equal nil, g.random([])
    assert_equal nil, g.random([nil])

    array = 10000.times.map {g.random([1, 2])}
    assert array.all? {|n| (1..10).include? n}
    assert_in_delta 1.5, array.sum.to_f / array.size, 0.02
  end

  def test_randomSeed()
    g = graphics
                    r0 = g.random 1
    g.randomSeed 1; r1 = g.random 1
    g.randomSeed 2; r2 = g.random 1

    assert_equal 3, [r0, r1, r2].uniq.size

    g.randomSeed 1
    assert_equal r1, g.random(1)
  end

  def test_randomSeed_choice()
    g = graphics
                    r0 = g.random((0...10000).to_a)
    g.randomSeed 1; r1 = g.random((0...10000).to_a)
    g.randomSeed 2; r2 = g.random((0...10000).to_a)

    assert_equal 3, [r0, r1, r2].uniq.size

    g.randomSeed 1
    assert_equal r1, g.random((0...10000).to_a)
  end

  def test_noise()
    g = graphics
    assert_equal     g.noise(0.1, 0.2, 0.3), g.noise(0.1, 0.2, 0.3)
    assert_not_equal g.noise(0.1, 0.2, 0.3), g.noise(0.2, 0.2, 0.3)
    assert_not_equal g.noise(0.1, 0.2, 0.3), g.noise(0.1, 0.3, 0.3)
    assert_not_equal g.noise(0.1, 0.2, 0.3), g.noise(0.1, 0.2, 0.4)
  end

  def test_noiseSeed()
    g = graphics
                   n0 = g.noise 0.1, 0.2, 0.3
    g.noiseSeed 1; n1 = g.noise 0.1, 0.2, 0.3
    g.noiseSeed 2; n2 = g.noise 0.1, 0.2, 0.3

    assert_equal 3, [n0, n1, n2].uniq.size

    g.noiseSeed 1
    assert_equal n1, g.noise(0.1, 0.2, 0.3)
  end

  def test_noiseDetail()
    g = graphics
                     n0 = g.noise 0.1, 0.2, 0.3
    g.noiseDetail 1; n1 = g.noise 0.1, 0.2, 0.3
    g.noiseDetail 2; n2 = g.noise 0.1, 0.2, 0.3
    g.noiseDetail 3; n3 = g.noise 0.1, 0.2, 0.3
    g.noiseDetail 4; n4 = g.noise 0.1, 0.2, 0.3

    assert_equal 4,  [n1, n2, n3, n4].uniq.size
    assert_equal n4, n0
  end

end# TestGraphicsContext
