require_relative 'helper'


class TestGraphics < Test::Unit::TestCase

  def test_dup()
    g = graphics 1, 1
    assert_equal g.color(0, 0, 0, 0),     g.dup.loadPixels[0]

    g.fill 255, 0, 0
    g.noStroke
    g.beginDraw {g.rect 0, 0, 1, 1}
    assert_equal g.color(255, 0, 0, 255), g.dup.loadPixels[0]

    g.fill 0, 255, 0
    assert_equal(
      g.color(0, 255, 0, 255),
      g.dup.tap {|gg| gg.beginDraw {gg.rect 0, 0, 1, 1}}.loadPixels[0])
  end

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
    temp_path(ext: '.png') do |path|
      assert_nothing_raised {g.save path}
      assert_equal_pixels g, g.loadImage(path)
    end
  end

  def test_inspect()
    assert_match %r|#<Processing::Graphics:0x\w{16}>|, graphics.inspect
  end

end# TestGraphics
