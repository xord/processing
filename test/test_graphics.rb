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

  def test_inspect()
    assert_match %r|#<Processing::Graphics:0x\w{16}>|, graphics.inspect
  end

end# TestGraphics
