# -*- coding: utf-8 -*-


require_relative '../helper'


class TestProcessingUtility < Test::Unit::TestCase

  C = RubySketch::Processing::Context

  def setup ()
    
  end

  def test_random ()
    assert_equal Float,  C.random(1).class
    assert_equal Float,  C.random(1.0).class
    assert_equal Symbol, C.random((:a..:z).to_a).class

    assert_not_equal C.random, C.random

    10000.times do
      n = C.random
      assert 0 <= n && n < 1

      n = C.random 1
      assert 0 <= n && n < 1

      n = C.random 1, 2
      assert 1.0 <= n && n < 2.0
    end
  end

end# TestProcessingUtility
