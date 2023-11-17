require_relative 'helper'


class TestDrawShape < Test::Unit::TestCase

  THRESHOLD_TO_BE_FIXED = 0.0

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

end# TestDrawShape
