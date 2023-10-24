require_relative 'helper'


class TestImage < Test::Unit::TestCase

  P = Processing

  def image(w = 10, h = 10, &block)
    img = Rays::Image.new w, h
    img.paint(&block) if block
    P::Image.new img
  end

  def test_set_color()
    g = graphics
    i = image(2, 2) {fill 0; rect 0, 0, 1, 1}

    assert_equal g.color(0, 0, 0),   i.get(0, 0)

    i.set 0, 0,  g.color(0, 255, 0)
    assert_equal g.color(0, 255, 0), i.get(0, 0)

    i.set 0, 0,  g.color(0, 0, 255)
    assert_equal g.color(0, 0, 255), i.get(0, 0)
  end

  def test_get_color()
    g = graphics
    i = image 2, 2 do
      fill 1, 0, 0; rect 0, 0, 1, 1
      fill 0, 1, 0; rect 1, 0, 1, 1
      fill 0, 0, 1; rect 0, 1, 1, 1
    end

    assert_equal g.color(255, 0, 0), i.get(0, 0)
    assert_equal g.color(0, 255, 0), i.get(1, 0)
    assert_equal g.color(0, 0, 255), i.get(0, 1)
  end

  def test_inspect()
    assert_match %r|#<Processing::Image:0x\w{16}>|, image.inspect
  end

end# TestImage
