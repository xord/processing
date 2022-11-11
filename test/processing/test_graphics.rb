# -*- coding: utf-8 -*-


require_relative 'helper'


class TestProcessingGraphics < Test::Unit::TestCase

  P = RubySketch::Processing

  def graphics(w = 10, h = 10)
    P::Graphics.new w, h
  end

  def test_beginDraw()
    g = graphics
    g.beginDraw
    assert_raise {g.beginDraw}
  end

end# TestProcessingGraphics
