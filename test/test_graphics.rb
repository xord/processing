require_relative 'helper'


class TestGraphics < Test::Unit::TestCase

  def test_beginDraw()
    g = graphics
    g.beginDraw
    assert_raise {g.beginDraw}
  end

  def test_save()
    g = graphics 100, 100
    g.beginDraw do
      g.background 200
      g.fill 255
      g.stroke 0
      g.ellipseMode :corner
      g.ellipse 0, 0, g.width, g.height
    end
    temppath(ext: 'png') do |path|
      assert_nothing_raised {g.save path}
      assert_equal_pixels g, g.loadImage(path)
    end
  end

  def test_inspect()
    assert_match %r|#<Processing::Graphics:0x\w{16}>|, graphics.inspect
  end

end# TestGraphics
