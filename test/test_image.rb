require_relative 'helper'


class TestImage < Test::Unit::TestCase

  P = Processing

  def image(w = 10, h = 10)
    P::Image.new(Rays::Image.new w, h)
  end

  def test_inspect()
    assert_match %r|#<Processing::Image:0x\w{16}>|, image.inspect
  end

end# TestImage
