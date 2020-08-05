# -*- coding: utf-8 -*-


require_relative '../helper'


class TestProcessingUtility < Test::Unit::TestCase

  class Context
    include RubySketch::Processing::Context
  end

  def context
    Context.new
  end

  def test_random ()
    c = context

    assert_equal Float,  c.random(1).class
    assert_equal Float,  c.random(1.0).class
    assert_equal Symbol, c.random((:a..:z).to_a).class

    assert_not_equal c.random, c.random

    10000.times do
      n = c.random
      assert 0 <= n && n < 1

      n = c.random 1
      assert 0 <= n && n < 1

      n = c.random 1, 2
      assert 1.0 <= n && n < 2.0
    end
  end

end# TestProcessingUtility
