require 'test_helper'

module Stronger
  class PropertySetTest < Minitest::Test
    include ExAssertions

    def test_valid_properties
      refute_ex_raised PropertyError, ->{make_set(valid_properties)},
        "Creating a propety set with valid values should not raise "\
        "an exception"
    end

    def test_extra_properties
      assert_ex_raised UndefinedProperty, ->{make_set(extra_properties)},
        "Extra values given to a property set should result in an "\
        "InvalidProperty exception"
    end

    def test_invalid_type
      assert_ex_raised InvalidProperty,
        ->{make_set(improperly_typed_properties)},
        "Giving values with the wrong type should result in "\
        "an InvalidProperty exception"
    end

    def test_missing_required
      assert_ex_raised MissingProperty, ->{make_set(insufficient_properties)},
        "Failing to supply required values should result in a MissingProperty "\
        "error"
    end

    def test_value_accessors
      name = 'Baron Bower'

      valid_set[:name] = name
      assert_equal name, valid_set[:name],
        "A property can be set and get using hash syntax"
      assert_ex_raised UndefinedProperty, ->{valid_set[:bobbyhill]},
        "Attempting to access a property not defined on the set "\
        "should result in an undefined property exception"
    end

    def test_set_invalid_value
      assert_ex_raised InvalidProperty, ->{valid_set[:name] = 25},
        "Attempting to set a property to an invalid value should raise an "\
        "invalid property exception"
      assert_ex_raised UndefinedProperty, ->{valid_set[:bobbyhill] = 25},
        "Attempting to set a property which does not exist should result "\
        "in an undefined property error"
      assert_ex_raised InvalidProperty, ->{valid_set[:name] = nil},
        "Attempting to make a property nil should result in "\
        " an InvalidProperty exception"
    end

    def test_delete_value
      address = valid_set[:address]
      assert_equal address, valid_set.delete(:address),
        "Deleting a non-required value should return that value"
      assert_ex_raised MissingProperty, ->{valid_set.delete(:name)},
        "Deleting a required value should result in a MissingProperty "\
        "exception"
    end

    def test_access_missing_value
      assert_ex_raised MissingProperty, ->{partial_valid_set[:address]},
        "A MissingProperty error should be raised when a property "\
        "which is not present is accessed"
    end

    def test_include?
      refute partial_valid_set.include?(:address),
        "Include returns false for a value which is not present"

      partial_valid_set[:address] = "hiya"
      assert partial_valid_set.include?(:address),
        "Include returns true for a value which is present"

      partial_valid_set.delete(:address)
      refute partial_valid_set.include?(:address),
        "Include still returns false for a valid which was present "\
        "but was deleted"
    end
      

    private

    def partial_valid_set
      @partial_avlid_set ||=
        make_set(valid_properties.tap{|p| p.delete :address})
    end

    def valid_set
      @valid_set ||= make_set(valid_properties)
    end

    def make_set(properties)
      PropertySet.new(properties, configured_properties)
    end

    def configured_properties
      @props ||= [
        Property.new(:name, type: String, required: true),
        Property.new(:address, type: String, required: false) ]
    end

    def insufficient_properties
      valid_properties.tap{|h| h.delete(:name) }
    end

    def improperly_typed_properties
      valid_properties.tap {|h| h[:name] = 25}
    end

    def valid_properties
      { name: "Joseph Miller",
        address: "2344 whatever dr. Raleigh NC 27610" }
    end

    def extra_properties
      valid_properties.merge({dog: 'Betty Beagle'})
    end
  end
end
