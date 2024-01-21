require_relative 'helper'


class TestUtility < Test::Unit::TestCase

  P = Processing

  include P::GraphicsContext

  def test_createVector()
    assert_equal P::Vector, createVector(1, 2).class
  end

  def test_createShader()
    fs = "void main() {gl_FragColor = vec4(1.0);}"
    assert_equal P::Shader, createShader(nil, fs).class
  end

end# TestUtility
