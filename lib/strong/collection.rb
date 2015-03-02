module Stronger
  module Collection
    Interface = Stronger::Interface.new(:type)
    using TypeChecking

    attr_reader :type
    def initialize(type, *rest)
      @type = type
      super(*rest)
    end

    private

    def check_value_type!(val)
      unless val.is_strong?(type)
        raise TypeError, "#{self} expects values of type: #{type}" 
      end
    end

    def check_collection_type!(col)
      unless col.implements?(Collection::Interface) and col.type < type
        raise TypeError,
          "#{self} may only be concatenated with an array of the same type!"
      end
    end
  end
end
