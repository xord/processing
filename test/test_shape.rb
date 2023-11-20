require_relative 'helper'


class TestShape < Test::Unit::TestCase

  P = Processing
  G = P::GraphicsContext

  def createShape(kind = nil, *args, g: graphics)
    g.createShape kind, *args
  end

  def vec(*args)
    P::Vector.new(*args)
  end

  def test_size()
    assert_equal [0,  0],  createShape                         .then {|s| [s.w, s.h]}
    assert_equal [30, 50], createShape(G::RECT, 10, 20, 30, 50).then {|s| [s.w, s.h]}
    assert_equal [20, 30], createShape(G::LINE, 10, 20, 30, 50).then {|s| [s.w, s.h]}
  end

  def test_visibility()
    gfx = graphics 100, 100 do |g|
      g.background 0
    end
    assert_equal 1, get_pixels(gfx).uniq.size

    gfx = graphics 100, 100 do |g|
      s = createShape G::RECT, 10, 20, 30, 40, g: g
      assert_true s.isVisible
      assert_true s.visible?

      g.background 0
      g.fill 255
      g.noStroke
      g.shape s
    end
    assert_equal 2, get_pixels(gfx).uniq.size

    gfx = graphics 100, 100 do |g|
      s = createShape G::RECT, 10, 20, 30, 40, g: g
      s.setVisible false
      assert_false s.isVisible
      assert_false s.visible?

      g.background 0
      g.fill 255
      g.noStroke
      g.shape s
    end
    assert_equal 1, get_pixels(gfx).uniq.size
  end

  def test_beginShape_points()
    assert_equal_draw_vertices 'strokeWeight 200', <<~END
      s.beginShape POINTS
      s.vertex 200, 300
      s.vertex 500, 600
      s.endShape
    END
  end

  def test_beginShape_lines()
    assert_equal_draw_vertices 'strokeWeight 200', <<~END
      s.beginShape LINES
      s.vertex 100, 200
      s.vertex 300, 400
      s.vertex 500, 600
      s.vertex 700, 800
      s.endShape
    END
  end

  def test_beginShape_triangles()
    assert_equal_draw_vertices <<~END
      s.beginShape TRIANGLES
      s.vertex 100, 100
      s.vertex 100, 500
      s.vertex 400, 200
      s.vertex 500, 100
      s.vertex 500, 500
      s.vertex 900, 200
      s.endShape
    END
  end

  def test_beginShape_triangle_fan()
    assert_equal_draw_vertices <<~END
      s.beginShape TRIANGLE_FAN
      s.vertex 100, 100
      s.vertex 100, 500
      s.vertex 200, 600
      s.vertex 300, 500
      s.vertex 400, 600
      s.vertex 500, 200
      s.vertex 400, 100
      s.endShape
    END
  end

  def test_beginShape_triangle_strip()
    assert_equal_draw_vertices <<~END
      s.beginShape TRIANGLE_STRIP
      s.vertex 100, 100
      s.vertex 100, 900
      s.vertex 500, 200
      s.vertex 500, 800
      s.vertex 900, 100
      s.vertex 900, 900
      s.endShape
    END
  end

  def test_beginShape_quads()
    assert_equal_draw_vertices <<~END
      s.beginShape QUADS
      s.vertex 100, 100
      s.vertex 200, 500
      s.vertex 300, 400
      s.vertex 400, 200
      s.vertex 500, 100
      s.vertex 600, 500
      s.vertex 700, 400
      s.vertex 800, 200
      s.endShape
    END
  end

  def test_beginShape_quad_strip()
    assert_equal_draw_vertices <<~END
      s.beginShape QUAD_STRIP
      s.vertex 100, 100
      s.vertex 100, 500
      s.vertex 500, 200
      s.vertex 500, 400
      s.vertex 900, 100
      s.vertex 900, 500
      s.endShape
    END
  end

  def test_beginShape_tess()
    assert_equal_draw_vertices <<~END
      s.beginShape TESS
      s.vertex 100, 100
      s.vertex 100, 500
      s.vertex 500, 500
      s.vertex 500, 400
      s.vertex 300, 400
      s.vertex 300, 300
      s.vertex 500, 300
      s.vertex 500, 100
      s.endShape
    END
  end

  def test_beginShape_polygon()
    assert_equal_draw_vertices <<~END
      s.beginShape
      s.vertex 100, 100
      s.vertex 100, 500
      s.vertex 500, 500
      s.vertex 500, 400
      s.vertex 300, 400
      s.vertex 300, 300
      s.vertex 500, 300
      s.vertex 500, 100
      s.endShape
    END
  end

  def test_beginShape_twice()
    first, second = <<~FIRST, <<~SECOND
      s.vertex 100, 100
      s.vertex 100, 500
      s.vertex 400, 500
      s.vertex 400, 300
    FIRST
      s.vertex 500, 300
      s.vertex 500, 500
      s.vertex 800, 500
      s.vertex 800, 100
    SECOND

    assert_equal_draw <<~EXPECTED, <<~ACTUAL
      s = self
      s.beginShape
      #{first}
      #{second}
      s.endShape
    EXPECTED
      s = createShape
      s.beginShape
      #{first}
      s.endShape
      s.beginShape
      #{second}
      s.endShape
      shape s
    ACTUAL

    assert_equal_draw <<~EXPECTED, <<~ACTUAL
      s = self
      s.beginShape
      #{first}
      #{second}
      s.endShape CLOSE
    EXPECTED
      s = createShape
      s.beginShape
      #{first}
      s.endShape
      s.beginShape
      #{second}
      s.endShape CLOSE
      shape s
    ACTUAL

    assert_equal_draw <<~EXPECTED, <<~ACTUAL
      s = self
      s.beginShape
      #{first}
      #{second}
      s.endShape
    EXPECTED
      s = createShape
      s.beginShape TRIANGLES
      #{first}
      s.endShape
      s.beginShape
      #{second}
      s.endShape
      shape s
    ACTUAL
  end

  def test_getVertex()
    s = createShape
    s.beginShape
    s.vertex 1, 2
    s.vertex 3, 4
    s.vertex 5, 6
    s.endShape

    assert_equal vec(1, 2), s.getVertex(0)
    assert_equal vec(3, 4), s.getVertex(1)
    assert_equal vec(5, 6), s.getVertex(-1)
    assert_equal vec(3, 4), s.getVertex(-2)
  end

  def test_setVertex()
    s = createShape
    s.beginShape
    s.vertex 1, 2
    s.vertex 3, 4
    s.vertex 5, 6
    s.endShape

    points = -> do
      s.getVertexCount.times.map {|i|
        s.getVertex(i).then {|v| [v.x, v.y]}
      }.flatten
    end

    s.setVertex(0, vec(7, 8))
    assert_equal [7, 8, 3, 4, 5, 6],  points.call

    s.setVertex(-1, vec(9, 10))
    assert_equal [7, 8, 3, 4, 9, 10], points.call
  end

  def test_getVertexCount()
    s = createShape
    s.beginShape G::TRIANGLES
    assert_equal 0, s.getVertexCount

    s.vertex 1, 2
    assert_equal 1, s.getVertexCount

    s.vertex 3, 4
    assert_equal 2, s.getVertexCount

    s.vertex 5, 6
    assert_equal 3, s.getVertexCount

    s.endShape
    assert_equal 3, s.getVertexCount
  end

  def assert_equal_draw_vertices(*shared_header, source)
    assert_equal_draw *shared_header, <<~EXPECTED, <<~ACTUAL, label: test_label
      s = self
      #{source}
    EXPECTED
      s = createShape
      #{source}
      shape s
    ACTUAL
  end

end# TestShape
