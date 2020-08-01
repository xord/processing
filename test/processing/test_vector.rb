# -*- coding: utf-8 -*-


require_relative '../helper'


class TestProcessingVector < Test::Unit::TestCase

  V = RubySketch::Processing::Vector

  M = Math

  PI = M::PI

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

  def test_array ()
    assert_equal [1, 2, 3], vec(1, 2, 3).array
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
    v2 = vec 4, 5, 6
    assert_equal vec(5, 7, 9), v1 + v2
    assert_equal vec(1, 2, 3), v1
    assert_equal vec(4, 5, 6), v2

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
    v2 = vec 1, 2, 3
    assert_equal vec(8, 6, 4), v1 - v2
    assert_equal vec(9, 8, 7), v1
    assert_equal vec(1, 2, 3), v2

    assert_equal vec(8, 8, 7), vec(9, 8, 7) - 1

    assert_equal vec(9, 8, 7), vec(9, 8, 7) - []
    assert_equal vec(8, 8, 7), vec(9, 8, 7) - [1]
    assert_equal vec(8, 6, 7), vec(9, 8, 7) - [1, 2]
    assert_equal vec(8, 6, 4), vec(9, 8, 7) - [1, 2, 3]

    assert_equal vec(8, 6, 4), vec(9, 8, 7) -   vec(1, 2, 3)
    assert_equal vec(8, 6, 4), vec(9, 8, 7) - point(1, 2, 3)
  end

  def test_op_mult ()
    v = vec 1, 2, 3
    assert_equal vec(2, 4, 6), v * 2
    assert_equal vec(1, 2, 3), v
  end

  def test_op_div ()
    v = vec 2, 4, 6
    assert_equal vec(1, 2, 3), v / 2
    assert_equal vec(2, 4, 6), v
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

  def test_mag ()
    assert_in_delta M.sqrt(5),  vec(1, 2)   .mag, 0.000001
    assert_in_delta M.sqrt(14), vec(1, 2, 3).mag, 0.000001
  end

  def test_magSq ()
    assert_equal 5,  vec(1, 2)   .magSq
    assert_equal 14, vec(1, 2, 3).magSq
  end

  def test_setMag ()
    v = vec 3, 4, 0
    assert_equal vec(6, 8, 0), v.setMag(10)
    assert_equal vec(6, 8, 0), v

    v      = vec 3, 4, 0
    result = vec
    assert_equal vec(6, 8, 0), v.setMag(result, 10)
    assert_equal vec(3, 4, 0), v
    assert_equal vec(6, 8, 0), result
  end

  def test_normalize ()
    v      = vec 1, 2, 3
    normal = v / v.mag
    assert_equal normal, v.normalize
    assert_equal normal, v

    v      = vec 1, 2, 3
    result = vec
    assert_equal normal,       v.normalize(result)
    assert_equal vec(1, 2, 3), v
    assert_equal normal,       result
  end

  def test_limit ()
    v = vec 1, 2, 3
    assert_in_delta 1, v.limit(1).mag, 0.000001
    assert_in_delta 1, v         .mag, 0.000001

    assert_in_delta 1,                vec(1, 2, 3).limit(1).mag, 0.000001
    assert_in_delta 2,                vec(1, 2, 3).limit(2).mag, 0.000001
    assert_in_delta 3,                vec(1, 2, 3).limit(3).mag, 0.000001
    assert_in_delta vec(1, 2, 3).mag, vec(1, 2, 3).limit(4).mag, 0.000001
  end

  def test_dist ()
    v1 = vec 1, 2, 3
    v2 = vec 4, 5, 6

    assert_in_delta M.sqrt((4-1)**2 + (5-2)**2 + (6-3)**2), v1.dist(v2), 0.000001
    assert_equal vec(1, 2, 3), v1
    assert_equal vec(4, 5, 6), v2

    assert_in_delta M.sqrt((4-1)**2 + (5-2)**2 + (6-3)**2), V.dist(v1, v2), 0.000001
    assert_equal vec(1, 2, 3), v1
    assert_equal vec(4, 5, 6), v2
  end

  def test_dot ()
    v1 = vec 1, 2, 3
    v2 = vec 4, 5, 6

    assert_equal 1*4 + 2*5 + 3*6, v1.dot(4, 5, 6)
    assert_equal vec(1, 2, 3), v1

    assert_equal 1*4 + 2*5 + 3*6, v1.dot(v2)
    assert_equal vec(1, 2, 3), v1
    assert_equal vec(4, 5, 6), v2

    assert_equal 1*4 + 2*5 + 3*6, V.dot(v1, v2)
    assert_equal vec(1, 2, 3), v1
    assert_equal vec(4, 5, 6), v2
  end

  def test_cross ()
    v1 = vec 1, 0, 0
    v2 = vec 0, 1, 0

    assert_equal vec(0, 0, 1), v1.cross(0, 1, 0)
    assert_equal vec(1, 0, 0), v1

    result = vec 1, 2, 3
    assert_equal vec(0, 0, 1), v1.cross(v2, result)
    assert_equal vec(1, 0, 0), v1
    assert_equal vec(0, 1, 0), v2
    assert_equal vec(0, 0, 1), result

    result = vec 1, 2, 3
    assert_equal vec(0, 0, 1), V.cross(v1, v2, result)
    assert_equal vec(1, 0, 0), v1
    assert_equal vec(0, 1, 0), v2
    assert_equal vec(0, 0, 1), result
  end

  def test_rotate ()
    angle   = PI * 2 * 0.1
    context = Object.new.tap {|o| def o.toAngle__ (angle); angle; end}

    v = vec 1, 0, 0
    assert_equal vec(M.cos(angle), M.sin(angle), 0), v.rotate(angle)
    assert_equal vec(M.cos(angle), M.sin(angle), 0), v

    v = vec 1, 0, 0, context: context
    assert_equal vec(M.cos(angle), M.sin(angle), 0), v.rotate(36)
  end

  def test_fromAngle ()
    angle  = PI * 2 * 0.1
    result = vec
    assert_equal vec(M.cos(angle), M.sin(angle), 0), V.fromAngle(angle)
    assert_equal vec(M.cos(angle), M.sin(angle), 0), V.fromAngle(angle, result)
    assert_equal vec(M.cos(angle), M.sin(angle), 0), result
  end

  def test_heading ()
    angle = PI * 1 * 0.1
    assert_in_delta  angle, V.fromAngle( angle).heading, 0.000001
    assert_in_delta -angle, V.fromAngle(-angle).heading, 0.000001
  end

  def test_angleBetween ()
    v1 = V.fromAngle PI * 0.25
    v2 = V.fromAngle PI * 0.75
    assert_in_delta PI / 2, V.angleBetween(v1, v2), 0.000001
  end

  def test_lerp ()
    assert_equal vec(0.5, 0.5, 0.5), vec(0, 0, 0).lerp(vec(1, 1, 1),    0.5)
    assert_equal vec(0.5, 0.5, 0.5), vec(0, 0, 0).lerp(    1, 1, 1,     0.5)
    assert_equal vec(0.5, 0.5, 0.5), V.lerp(vec(0, 0, 0), vec(1, 1, 1), 0.5)
  end

  def test_random2D ()
    v1 = V.random2D
    v2 = V.random2D
    assert          v1.x != 0
    assert          v1.y != 0
    assert_equal 0, v1.z
    assert          v2.x != 0
    assert          v2.y != 0
    assert_equal 0, v2.z
    assert_not_equal v1, v2
    assert_in_delta 1, v1.mag, 0.000001
    assert_in_delta 1, v2.mag, 0.000001
  end

  def test_random3D ()
    v1 = V.random3D
    v2 = V.random3D
    assert v1.x != 0
    assert v1.y != 0
    assert v1.z != 0
    assert v2.x != 0
    assert v2.y != 0
    assert v2.z != 0
    assert_not_equal v1, v2
    assert_in_delta 1, v1.mag, 0.000001
    assert_in_delta 1, v2.mag, 0.000001
  end

end# TestProcessingVector
