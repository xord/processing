require_relative 'helper'


class TestSVG < Test::Unit::TestCase

  def test_color_code()
    assert_svg_draw '<rect width="500" height="600" fill="#ffaa55"/>'
    assert_svg_draw '<rect width="500" height="600" fill="#ffaa5599"/>'
    assert_svg_draw '<rect width="500" height="600" fill="#fa5"/>'
    assert_svg_draw '<rect width="500" height="600" fill="#fa59"/>'
    assert_svg_draw '<rect width="500" height="600" fill="red"/>'
  end

  def test_line()
    assert_svg_draw <<~END
      <line x1="200" y1="300" x2="500" y2="600" stroke="black" stroke-width="300"/>
    END
  end

  def test_rect()
    assert_svg_draw '<rect width="500" height="600"/>'
    assert_svg_draw '<rect width="500" height="600" x="100" y="200"/>'
    assert_svg_draw '<rect width="500" height="600" x="100" y="200" rx="100" ry="100"/>'

    assert_svg_draw <<~END, threshold: THRESHOLD_TO_BE_FIXED
      <rect width="500" height="600" x="100" y="200" rx="100" ry="200"/>
    END
    assert_svg_draw <<~END, threshold: THRESHOLD_TO_BE_FIXED
      <rect width="500" height="600" x="100" y="200" rx="200" ry="100"/>
    END
  end

  def test_circle()
    assert_svg_draw '<circle cx="500" cy="600" r="200"/>'
  end

  def test_ellipse()
    assert_svg_draw '<ellipse cx="500" cy="600" rx="200" ry="300"/>'
  end

  def test_polyline()
    assert_svg_draw <<~END
      <polyline points="200,300 500,400 600,700 300,800" stroke="black" stroke-width="300"/>
    END
    assert_svg_draw <<~END
      <polyline points="200,300 500,400 600,700 300,800" stroke="black" stroke-width="300"
        fill="none"/>
    END
  end

  def test_polygon()
    assert_svg_draw <<~END
      <polygon points="200,300 500,400 600,700 300,800" stroke="black" stroke-width="200"/>
    END
    assert_svg_draw <<~END
      <polygon points="200,300 500,400 600,700 300,800" stroke="black" stroke-width="200"
        fill="none"/>
    END
  end

end# TestSVG
