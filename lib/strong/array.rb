require 'strong/collection'
module Stronger
  class TypedArray < ::Array
    include Collection
    [:push,  :shift, :[]=].each do |name|
      define_method(name) do |value|
        check_value_type!(value)
        super(value)
      end
    end

    def concat(arr)
      check_collection_type!(arr)
    end
  end
end
