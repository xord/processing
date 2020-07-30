# -*- coding: utf-8 -*-


require_relative '../helper'


class TestProcessingVector < Test::Unit::TestCase

  V = RubySketch::Processing::Vector

  def vec (*args)
    V.new *args
  end

  def point (*args)
    Rays::Point.new *args
  end

  def test_initialize ()
    assert_equal vec(0, 0, 0), vec()
    assert_equal vec(1, 0, 0), vec(1)
    assert_equal vec(1, 2, 0), vec(1, 2)
    assert_equal vec(1, 2, 3), vec(1, 2, 3)

    assert_equal vec(0, 0, 0), vec([])
    assert_equal vec(1, 0, 0), vec([1])
    assert_equal vec(1, 2, 0), vec([1, 2])
    assert_equal vec(1, 2, 3), vec([1, 2, 3])

    assert_equal vec(1, 2, 3), vec(vec 1, 2, 3)
    assert_equal vec(1, 2, 3), vec(point 1, 2, 3)
  end

  def test_set ()
    v0 = vec 9, 9, 9

    v = v0.dup; v.set;         assert_equal vec(0, 0, 0), v
    v = v0.dup; v.set 1;       assert_equal vec(1, 0, 0), v
    v = v0.dup; v.set 1, 2;    assert_equal vec(1, 2, 0), v
    v = v0.dup; v.set 1, 2, 3; assert_equal vec(1, 2, 3), v

    v = v0.dup; v.set [];        assert_equal vec(0, 0, 0), v
    v = v0.dup; v.set [1];       assert_equal vec(1, 0, 0), v
    v = v0.dup; v.set [1, 2];    assert_equal vec(1, 2, 0), v
    v = v0.dup; v.set [1, 2, 3]; assert_equal vec(1, 2, 3), v

    v = v0.dup; v.set   vec(1, 2, 3); assert_equal vec(1, 2, 3), v
    v = v0.dup; v.set point(1, 2, 3); assert_equal vec(1, 2, 3), v
  end

  def test_dup ()
    v1 = vec 1, 2, 3
    assert_equal vec(1, 2, 3), v1

    v2 = v1.dup
    assert_equal vec(1, 2, 3), v1
    assert_equal vec(1, 2, 3), v2

    v1.set 7, 8, 9
    assert_equal vec(7, 8, 9), v1
    assert_equal vec(1, 2, 3), v2
  end

  def test_copy ()
    v1 = vec 1, 2, 3
    assert_equal vec(1, 2, 3), v1

    v2 = v1.copy
    assert_equal vec(1, 2, 3), v1
    assert_equal vec(1, 2, 3), v2

    v1.set 7, 8, 9
    assert_equal vec(7, 8, 9), v1
    assert_equal vec(1, 2, 3), v2
  end

  def test_xyz ()
    v = vec 1, 2, 3
    assert_equal vec(1, 2, 3), v
    assert_equal [1, 2, 3], [v.x, v.y, v.z]

    v.x = 7
    assert_equal vec(7, 2, 3), v

    v.y = 8
    assert_equal vec(7, 8, 3), v

    v.z = 9
    assert_equal vec(7, 8, 9), v
  end

  def test_add ()
    v = vec 1, 2, 3
    v.add 4, 5, 6
    assert_equal vec(5, 7, 9), v

    assert_equal vec(1, 2, 3), vec(1, 2, 3).add()
    assert_equal vec(5, 2, 3), vec(1, 2, 3).add(4)
    assert_equal vec(5, 7, 3), vec(1, 2, 3).add(4, 5)
    assert_equal vec(5, 7, 9), vec(1, 2, 3).add(4, 5, 6)

    assert_equal vec(1, 2, 3), vec(1, 2, 3).add([])
    assert_equal vec(5, 2, 3), vec(1, 2, 3).add([4])
    assert_equal vec(5, 7, 3), vec(1, 2, 3).add([4, 5])
    assert_equal vec(5, 7, 9), vec(1, 2, 3).add([4, 5, 6])

    assert_equal vec(5, 7, 9), vec(1, 2, 3).add(  vec(4, 5, 6))
    assert_equal vec(5, 7, 9), vec(1, 2, 3).add(point(4, 5, 6))
  end

  def test_sub ()
    v = vec 9, 8, 7
    v.sub 1, 2, 3
    assert_equal vec(8, 6, 4), v

    assert_equal vec(9, 8, 7), vec(9, 8, 7).sub()
    assert_equal vec(8, 8, 7), vec(9, 8, 7).sub(1)
    assert_equal vec(8, 6, 7), vec(9, 8, 7).sub(1, 2)
    assert_equal vec(8, 6, 4), vec(9, 8, 7).sub(1, 2, 3)

    assert_equal vec(9, 8, 7), vec(9, 8, 7).sub([])
    assert_equal vec(8, 8, 7), vec(9, 8, 7).sub([1])
    assert_equal vec(8, 6, 7), vec(9, 8, 7).sub([1, 2])
    assert_equal vec(8, 6, 4), vec(9, 8, 7).sub([1, 2, 3])

    assert_equal vec(8, 6, 4), vec(9, 8, 7).sub(  vec(1, 2, 3))
    assert_equal vec(8, 6, 4), vec(9, 8, 7).sub(point(1, 2, 3))
  end

  def test_mult ()
    v = vec 1, 2, 3
    v.mult 2
    assert_equal vec(2, 4, 6), v
  end

  def test_div ()
    v = vec 2, 4, 6
    v.div 2
    assert_equal vec(1, 2, 3), v
  end

  def test_op_add ()
    v1 = vec 1, 2, 3
    v2 = v1 + vec(4, 5, 6)
    assert_equal vec(1, 2, 3), v1
    assert_equal vec(5, 7, 9), v2

    assert_equal vec(5, 2, 3), vec(1, 2, 3) + 4

    assert_equal vec(1, 2, 3), vec(1, 2, 3) + []
    assert_equal vec(5, 2, 3), vec(1, 2, 3) + [4]
    assert_equal vec(5, 7, 3), vec(1, 2, 3) + [4, 5]
    assert_equal vec(5, 7, 9), vec(1, 2, 3) + [4, 5, 6]

    assert_equal vec(5, 7, 9), vec(1, 2, 3) +   vec(4, 5, 6)
    assert_equal vec(5, 7, 9), vec(1, 2, 3) + point(4, 5, 6)
  end

  def test_op_sub ()
    v1 = vec 9, 8, 7
    v2 = v1 - vec(1, 2, 3)
    assert_equal vec(9, 8, 7), v1
    assert_equal vec(8, 6, 4), v2

    assert_equal vec(8, 8, 7), vec(9, 8, 7) - 1

    assert_equal vec(9, 8, 7), vec(9, 8, 7) - []
    assert_equal vec(8, 8, 7), vec(9, 8, 7) - [1]
    assert_equal vec(8, 6, 7), vec(9, 8, 7) - [1, 2]
    assert_equal vec(8, 6, 4), vec(9, 8, 7) - [1, 2, 3]

    assert_equal vec(8, 6, 4), vec(9, 8, 7) -   vec(1, 2, 3)
    assert_equal vec(8, 6, 4), vec(9, 8, 7) - point(1, 2, 3)
  end

  def test_op_mult ()
    v1 = vec 1, 2, 3
    v2 = v1 * 2
    assert_equal vec(1, 2, 3), v1
    assert_equal vec(2, 4, 6), v2
  end

  def test_op_div ()
    v1 = vec 2, 4, 6
    v2 = v1 / 2
    assert_equal vec(2, 4, 6), v1
    assert_equal vec(1, 2, 3), v2
  end

  def test_fun_add ()
    v1     = vec 1, 2, 3
    v2     = vec 4, 5, 6
    result = vec
    assert_equal vec(5, 7, 9), V.add(v1, v2, result)
    assert_equal vec(1, 2, 3), v1
    assert_equal vec(4, 5, 6), v2
    assert_equal vec(5, 7, 9), result
  end

  def test_fun_sub ()
    v1     = vec 9, 8, 7
    v2     = vec 1, 2, 3
    result = vec
    assert_equal vec(8, 6, 4), V.sub(v1, v2, result)
    assert_equal vec(9, 8, 7), v1
    assert_equal vec(1, 2, 3), v2
    assert_equal vec(8, 6, 4), result
  end

  def test_fun_mult ()
    v1     = vec 1, 2, 3
    result = vec
    assert_equal vec(2, 4, 6), V.mult(v1, 2, result)
    assert_equal vec(1, 2, 3), v1
    assert_equal vec(2, 4, 6), result
  end

  def test_fun_div ()
    v1     = vec 2, 4, 6
    result = vec
    assert_equal vec(1, 2, 3), V.div(v1, 2, result)
    assert_equal vec(2, 4, 6), v1
    assert_equal vec(1, 2, 3), result
  end

end# TestProcessingVector
