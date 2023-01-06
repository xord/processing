# -*- coding: utf-8 -*-


require_relative 'helper'


class TestShader < Test::Unit::TestCase

  def color(*args)
    Rays::Color.new(*args)
  end

  def shader(vs = vshader, fs = fshader)
    Processing::Shader.new vs, fs
  end

  def vshader()
    "void main() {gl_Position = vec4(0.0, 0.0, 0.0, 1.0);}"
  end

  def fshader()
    "void main() {gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);}"
  end

  def test_initialize()
    assert shader vshader, fshader
    assert shader nil,     fshader

    assert_raise(ArgumentError) {shader "", fshader}
    assert_raise(ArgumentError) {shader vshader, ""}
    assert_raise(ArgumentError) {shader vshader, nil}
  end

  def test_uniform()
    sh = shader(nil, <<~END).tap {|s| s.set :val, 1.0}
      uniform float val;
      void main() {gl_FragColor = vec4(val, 0.0, 0.0, 1.0);}
    END

    graphics do |g, image|
      g.shader sh
      g.rect 0, 0, 10, 10
      assert_equal color(1, 0, 0, 1), image[0, 0]
    end
  end

end# TestShader
