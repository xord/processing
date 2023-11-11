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
    assert_fill        src, threshold: THRESHOLD_TO_BE_FIXED
    assert_stroke      src
    assert_fill_stroke src, threshold: THRESHOLD_TO_BE_FIXED
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
    assert_fill        src, 'endShape'
    assert_stroke      src, 'endShape'
    assert_fill_stroke src, 'endShape'
    assert_fill        src, 'endShape CLOSE'
    assert_stroke      src, 'endShape CLOSE'
    assert_fill_stroke src, 'endShape CLOSE'
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
    assert_fill        src, 'endShape'
    assert_stroke      src, 'endShape'
    assert_fill_stroke src, 'endShape'
    assert_fill        src, 'endShape CLOSE'
    assert_stroke      src, 'endShape CLOSE'
    assert_fill_stroke src, 'endShape CLOSE'
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
    assert_fill        src, 'endShape'
    assert_stroke      src, 'endShape', threshold: 0.98
    assert_fill_stroke src, 'endShape', threshold: 0.98
    assert_fill        src, 'endShape CLOSE'
    assert_stroke      src, 'endShape CLOSE', threshold: 0.98
    assert_fill_stroke src, 'endShape CLOSE', threshold: 0.98
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
    assert_fill        src, 'endShape'
    assert_stroke      src, 'endShape'
    assert_fill_stroke src, 'endShape'
    assert_fill        src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
    assert_stroke      src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
    assert_fill_stroke src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
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
    assert_fill        src, 'endShape'
    assert_stroke      src, 'endShape'
    assert_fill_stroke src, 'endShape'
    assert_fill        src, 'endShape CLOSE'
    assert_stroke      src, 'endShape CLOSE'
    assert_fill_stroke src, 'endShape CLOSE'
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
    assert_fill        src, 'endShape'
    assert_stroke      src, 'endShape'
    assert_fill_stroke src, 'endShape'
    assert_fill        src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
    assert_stroke      src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
    assert_fill_stroke src, 'endShape CLOSE', threshold: THRESHOLD_TO_BE_FIXED
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
    assert_fill        src, 'endShape'
    assert_stroke      src, 'endShape'
    assert_fill_stroke src, 'endShape'
    assert_fill        src, 'endShape CLOSE'
    assert_stroke      src, 'endShape CLOSE'
    assert_fill_stroke src, 'endShape CLOSE'
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
    assert_fill        src, 'endShape'
    assert_stroke      src, 'endShape'
    assert_fill_stroke src, 'endShape'
    assert_fill        src, 'endShape CLOSE'
    assert_stroke      src, 'endShape CLOSE'
    assert_fill_stroke src, 'endShape CLOSE'
  end

end# TestDrawShape
