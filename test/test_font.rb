require_relative 'helper'


class TestFont < Test::Unit::TestCase

  P = Processing

  def font(*args)
    P::Font.new(Rays::Font.new(*args)).tap {|font|
      def font.intern()
        getInternal__
      end
    }
  end

  def test_initialize()
    assert_not_nil        font(nil)    .intern.name
    assert_equal 'Arial', font('Arial').intern.name

    assert_equal 12, font         .intern.size
    assert_equal 10, font(nil, 10).intern.size
  end

  def test_size()
    f  = font nil, 10
    id = f.intern.object_id

    assert_equal 10, f.intern.size

    f.setSize__ 11
    assert_equal 11, f.intern.size
    assert_not_equal id, f.intern.object_id

    f.setSize__ 10
    assert_equal 10, f.intern.size
    assert_equal id, f.intern.object_id
  end

  def test_inspect()
    assert_match %r|#<Processing::Font: name:'[\w\s]+' size:[\d\.]+>|, font.inspect
  end

  def test_list()
    assert_not P::Font.list.empty?
  end

end# TestFont
