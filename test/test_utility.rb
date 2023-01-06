# -*- coding: utf-8 -*-


require_relative 'helper'


class TestUtility < Test::Unit::TestCase

  P = Processing

  include P::GraphicsContext

  def test_random()
    assert_equal Float,  random(1).class
    assert_equal Float,  random(1.0).class
    assert_equal Symbol, random((:a..:z).to_a).class

    assert_not_equal random, random

    10000.times do
      n = random
      assert 0 <= n && n < 1

      n = random 1
      assert 0 <= n && n < 1

      n = random 1, 2
      assert 1.0 <= n && n < 2.0
    end
  end

  def test_createVector()
    assert_equal P::Vector, createVector(1, 2).class
  end

  def test_createShader()
    fs = "void main() {gl_FragColor = vec4(1.0);}"
    assert_equal P::Shader, createShader(nil, fs).class
  end

end# TestUtility
