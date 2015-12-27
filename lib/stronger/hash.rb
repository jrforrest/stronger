require 'stronger/collection'
module Stronger
  class TypedHash < ::Hash
    include Collection

    [:store, :[]=].each do |name|
      define_method(name) do |key, val|
        check_value_type!(val)
        super(key, val)
      end
    end
  end
end
