# -*- coding: utf-8 -*-


require_relative 'helper'


class TestGraphics < Test::Unit::TestCase

  P = Processing

  def graphics(w = 10, h = 10)
    P::Graphics.new w, h
  end

  def test_beginDraw()
    g = graphics
    g.beginDraw
    assert_raise {g.beginDraw}
  end

end# TestGraphics
