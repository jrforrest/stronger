require 'test_helper'

module Stronger 
  class ArrayTest < MiniTest::Test
    include ExAssertions

    DuckInterface = Interface.new(:quack)
    class Duck
      def quack; end
    end

    def test_array
      array = TypedArray.new(DuckInterface)
      refute_ex_raised TypeError, ->{array.push(Duck.new)},
        "The array allows objects of its configured type to be pushed."
      assert_ex_raised TypeError, ->{array.push(Object.new)},
        "Types not implementing the array's type will raise a TypeError "\
        "when pushed."
      assert_ex_raised TypeError, -> {array << Object.new},
        "Type checking works on << alias for array"
    end

    def test_concat
      assert_ex_raised TypeError,
        ->{ TypedArray.new(DuckInterface).concat(::Array.new) },
        "Can not concatenate a typed array with an un-typed array."
      assert_ex_raised TypeError,
        ->{ TypedArray.new(String).concat(Array.new(Fixnum)) },
        "Can not concatenate a typed array with a typed array "\
        "with an incompatible type"
      refute_ex_raised TypeError,
        ->{ TypedArray.new(Numeric).concat(TypedArray.new(Fixnum)) },
        "A typed array may be concatenated with another typed array which has "\
        "a type that implements its own type."
    end
  end
end
