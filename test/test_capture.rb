require_relative 'helper'


class TestCapture < Test::Unit::TestCase

  P = Processing

  def capture(*args, **kwargs)
    P::Capture.new(*args, **kwargs)
  end

  def test_inspect()
    assert_match %r|#<Processing::Capture:0x\w{16}>|, capture.inspect
  end

end# TestCapture
