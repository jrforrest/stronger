require 'test_helper'

module Stronger
  class TypeCheckingTest < MiniTest::Test
    include ExAssertions
    using TypeChecking

    DuckInterface = Interface.new(:quack, :walk)
    KickInterface = Interface.new(:give_it_the_boot)

    module Puntable
      implement KickInterface
    end

    class Duck
      implement DuckInterface
      include Puntable

      def quack; end
      def walk; end
    end

    class Goose
      def quack; end
      def walk; end
    end

    def test_class_type
      assert String.new.is_strong?(String),
        "Stronger typecheck should match on the class of the object"
    end

    def test_interface_instance
      assert duck.is_strong?(DuckInterface),
        "An object responding to all of the methods required by an "\
        "interface should be identify with that interface as a type"
      assert duck.is_strong?(Duck),
        "An object of a class should be identified with that class as "\
        "a type."
      assert duck.is_strong?(Puntable),
        "An object belonging to a class which includes a module should "\
        "be identified as a type of that module."
      assert_ex_raised NotImplementedError, ->{duck.give_it_the_boot},
        "An object belonging to an interface should have that method "\
        "defined with a default behavior of raising a NotImplementedError"
    end

    def test_ducktyped_interface
      assert Goose.instance_implements?(DuckInterface),
        "Even a class which does not explicitly implement an interface will "\
        "identify with that interface if it implements all "\
        "the necessary methods"
      refute Goose.instance_implements?(KickInterface),
        "A class does not implement an interface if it does not satisfy "\
        "all of its methods"
    end

    def test_instance_implements
      assert Duck.instance_implements?(KickInterface)
    end

    protected

    def duck
      @duck ||= Duck.new
    end
  end
end
