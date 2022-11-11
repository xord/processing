# -*- coding: utf-8 -*-


require_relative '../helper'


def graphics(width = 10, height = 10, &block)
  RubySketch::Processing::Graphics.new(width, height).tap do |g|
    g.beginDraw {block.call g, g.getInternal__} if block
  end
end
