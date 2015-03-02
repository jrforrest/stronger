require 'test_helper'

module Stronger
  class HashTest < MiniTest::Test
    include ExAssertions

    def test_hash
      hash = TypedHash.new(String)
      assert_ex_raised TypeError, ->{ hash[:one] = 1 },
        "Trying to set a value in the hash which is not of the type "\
        "with which the hash was instantiated should raise a TypeError"
      hash[:two] = "2"
      assert_equal "2", hash[:two],
        "Setting a hash value with the appropriate type should work."
      assert_ex_raised TypeError, ->{ hash.store(:three, 3)},
        "Store shouldn't work either."
    end
  end
end
