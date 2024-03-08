require_relative 'helper'


class TestSVG < Test::Unit::TestCase

  def test_color_code()
    assert_svg_draw '<rect width="500" height="600" fill="#ffaa55"/>'
    assert_svg_draw '<rect width="500" height="600" fill="#ffaa5599"/>'
    assert_svg_draw '<rect width="500" height="600" fill="#fa5"/>'
    assert_svg_draw '<rect width="500" height="600" fill="#fa59"/>'
    assert_svg_draw '<rect width="500" height="600" fill="red"/>'
  end

  def test_fill()
    assert_svg_draw '<rect width="500" height="600" fill="green"/>'
  end

  def test_stroke_and_width()
    assert_svg_draw <<~END
      <line x1="200" y1="300" x2="500" y2="600"
        stroke="green" stroke-width="200"/>
    END
  end

  def test_strokeCap()
    assert_svg_draw <<~END
      <line x1="200" y1="300" x2="500" y2="600"
        stroke="green" stroke-width="200" stroke-linecap="butt"/>
    END
    assert_svg_draw <<~END
      <line x1="200" y1="300" x2="500" y2="600"
        stroke="green" stroke-width="200" stroke-linecap="round"/>
    END
    assert_svg_draw <<~END
      <line x1="200" y1="300" x2="500" y2="600"
        stroke="green" stroke-width="200" stroke-linecap="square"/>
    END
  end

  def test_strokeJoin()
    assert_svg_draw <<~END
      <path d="M 200,300 L 500,600 L 300,800"
        stroke="green" stroke-width="200" stroke-linejoin="miter"/>
    END
    assert_svg_draw <<~END
      <path d="M 200,300 L 500,600 L 300,800"
        stroke="green" stroke-width="200" stroke-linejoin="miter-clip"/>
    END
    assert_svg_draw <<~END
      <path d="M 200,300 L 500,600 L 300,800"
        stroke="green" stroke-width="200" stroke-linejoin="round"/>
    END
    assert_svg_draw <<~END
      <path d="M 200,300 L 500,600 L 300,800"
        stroke="green" stroke-width="200" stroke-linejoin="bevel"/>
    END
    assert_svg_draw <<~END
      <path d="M 200,300 L 500,600 L 300,800"
        stroke="green" stroke-width="200" stroke-linejoin="arcs"/>
    END
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

  def test_path_Mm()
    assert_svg_draw path_xml "M 200,300 L 500,400"
    assert_svg_draw path_xml "m 200,300 L 500,400"
    assert_svg_draw path_xml "M 200,300 L 500,400 M 600,700 L 300,800"
    assert_svg_draw path_xml "M 200,300 L 500,400 m 100,300 L 300,800"
    assert_svg_draw path_xml "M 200,300   500,400   600,700   300,800"
    assert_svg_draw path_xml "m 200,300   300,100   100,300  -300,100"
  end

  def test_path_Ll()
    assert_svg_draw path_xml "M 200,300 L 500,400 L 600,700 L  300,800"
    assert_svg_draw path_xml "M 200,300 L 500,400   600,700    300,800"
    assert_svg_draw path_xml "M 200,300 l 300,100 l 100,300 l -300,100"
    assert_svg_draw path_xml "M 200,300 l 300,100   100,300   -300,100"
  end

  def test_path_Hh()
    assert_svg_draw path_xml "M 200,300 H 500 H 800"
    assert_svg_draw path_xml "M 200,300 H 500   800"
    assert_svg_draw path_xml "M 200,300 h 300 h 300"
    assert_svg_draw path_xml "M 200,300 h 300   300"
  end

  def test_path_Vv()
    assert_svg_draw path_xml "M 200,300 V 500 V 800"
    assert_svg_draw path_xml "M 200,300 V 500   800"
    assert_svg_draw path_xml "M 200,300 v 200 h 300"
    assert_svg_draw path_xml "M 200,300 h 200   300"
  end

  def test_path_Qq()
    assert_svg_draw path_xml "M 200,100 Q 800,300 300,400 Q 400,800 800,800"
    assert_svg_draw path_xml "M 200,100 Q 800,300 300,400   400,800 800,800"
    assert_svg_draw path_xml "M 200,100 q 600,200 100,300 q 100,400 500,400"
    assert_svg_draw path_xml "M 200,100 q 600,200 100,300   100,400 500,400"
  end

  def test_path_Tt()
    assert_svg_draw path_xml "M 200,100 T 300,400 T 800,800"
    assert_svg_draw path_xml "M 200,100 T 300,400   800,800"
    assert_svg_draw path_xml "M 200,100 t 100,300 t 500,400"
    assert_svg_draw path_xml "M 200,100 t 100,300   500,400"
  end

  def test_path_Cc()
    assert_svg_draw path_xml "M 200,100 C 800,200 300,300 700,400 C  600,800  300,500  200,700"
    assert_svg_draw path_xml "M 200,100 C 800,200 300,300 700,400    600,800  300,500  200,700"
    assert_svg_draw path_xml "M 200,100 c 600,100 100,200 500,300 c -100,400 -400,100 -500,300"
    assert_svg_draw path_xml "M 200,100 c 600,100 100,200 500,300   -100,400 -400,100 -500,300"
  end

  def test_path_Ss()
    assert_svg_draw path_xml "M 200,100 S 800,300 500,500 S 800,700  200,900"
    assert_svg_draw path_xml "M 200,100 S 800,300 500,500   800,700  200,900"
    assert_svg_draw path_xml "M 200,100 s 600,200 300,400 s 300,200 -300,400"
    assert_svg_draw path_xml "M 200,100 s 600,200 300,400   300,200 -300,400"
  end

  def test_path_Aa()
    assert_svg_draw path_xml(<<~END), threshold: THRESHOLD_TO_BE_FIXED
      M 200,100 A 300,200 0 0 0 500,400 A 600,500 0 0 0 900,800
    END
    assert_svg_draw path_xml(<<~END), threshold: THRESHOLD_TO_BE_FIXED
      M 200,100 A 300,200 0 0 0 500,400   600,500 0 0 0 900,800
    END
    assert_svg_draw path_xml(<<~END), threshold: THRESHOLD_TO_BE_FIXED
      M 200,100 a 100,100 0 0 0 300,300 a 100,100 0 0 0 400,400
    END
    assert_svg_draw path_xml(<<~END), threshold: THRESHOLD_TO_BE_FIXED
      M 200,100 a 100,100 0 0 0 300,300   100,100 0 0 0 400,400
    END
  end

  def test_path_Zz()
    assert_svg_draw path_xml "M 200,300 L 500,400 L 600,700 L  300,800 Z"
    assert_svg_draw path_xml "M 200,300 L 500,400 L 600,700 L  300,800 z"
  end

  def test_group_fill()
    assert_svg_draw <<~END
      <g>
        <rect x="200" y="300" width="500" height="600" fill="green"/>
      </g>
    END
    assert_svg_draw <<~END
      <g fill="red">
        <rect x="200" y="300" width="500" height="600"/>
      </g>
    END
    assert_svg_draw <<~END
      <g fill="red">
        <rect x="200" y="300" width="500" height="600" fill="green"/>
      </g>
    END
  end

  def test_group_stroke()
    assert_svg_draw <<~END
      <g>
        <line x1="200" y1="300" x2="500" y2="600"
          stroke-width="200" stroke="green"/>
      </g>
    END
    assert_svg_draw <<~END
      <g stroke="red">
        <line x1="200" y1="300" x2="500" y2="600"
          stroke-width="200"/>
      </g>
    END
    assert_svg_draw <<~END
      <g stroke="red">
        <line x1="200" y1="300" x2="500" y2="600"
          stroke-width="200" stroke="green"/>
      </g>
    END
  end

  def test_group_stroke_width()
    assert_svg_draw <<~END
      <g>
        <line x1="200" y1="300" x2="500" y2="600" stroke="green" stroke-width="200"/>
      </g>
    END
    assert_svg_draw <<~END
      <g stroke-width="300">
        <line x1="200" y1="300" x2="500" y2="600" stroke="green" />
      </g>
    END
    assert_svg_draw <<~END
      <g stroke-width="300">
        <line x1="200" y1="300" x2="500" y2="600" stroke="green" stroke-width="400"/>
      </g>
    END
  end

  def test_path_data_shorthand()
    assert_svg_draw path_xml "M200,300L500,400L600,700L300,800"
    assert_svg_draw path_xml "M 200,300 l 500.99.400 0,200 -200,0.99.300,200"
    assert_svg_draw path_xml "M 200,800 l 500-200-200-200-300-300"
  end

  def path_xml(d)
    <<~END
      <path fill="none" stroke="black" stroke-width="100" d="#{d}"/>
    END
  end

end# TestSVG
