require 'test_helper'

module Stronger
  class PropertyDefinitionTest < MiniTest::Test
    include ExAssertions

    class PropertyDefinitionDummy
      include PropertyDefinition

      property :name, type: String
      property :address, type: String, required: false
    end

    def test_valid
      assert valid_dummy,
        "The valid dummy should instantiate with no errors"
      assert_equal valid_values[:name], valid_dummy.name,
        "The name method should expose the name"
    end

    def test_invalid
      assert_ex_raised MissingProperty, ->{invalid_dummy},
        "Creating an instance without all of the required properties "\
        "should result in a MissingProperty exception"
    end

    def test_set_invalid
      assert_ex_raised InvalidProperty, ->{valid_dummy.address = 25},
        "Attempting to set a property to the wrong type should raise an "\
        "InvalidProperty exception"
    end

    private

    def valid_dummy
      @valid_dummy ||= make_dummy(valid_values)
    end

    def invalid_dummy
      @invalid_dummuy ||= make_dummy(invalid_values)
    end

    def make_dummy(values)
      PropertyDefinitionDummy.new(**values)
    end

    def invalid_values
      {address: "one"}
    end

    def valid_values
      {name: "Riiiiiiick!"}
    end
  end
end
