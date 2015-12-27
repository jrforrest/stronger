require 'forwardable'

module Stronger
  class PropertyError < StandardError; end
  class InvalidProperty < PropertyError; end
  class UndefinedProperty < PropertyError; end
  class MissingProperty < PropertyError; end

  class PropertySet
    extend Forwardable

    # TODO: given_props should be called values
    def initialize(given_values, config_props)
      @config_props = config_props
      @values = Hash.new

      given_values.each {|k,v| set(k, v) }
      validate_required_present!
    end
    def_delegator :values, :include?

    def []=(key, value)
      property = get_property(key)
      validate_type!(value, property)
      values[key] = value
    end
    alias_method :set, :[]=

    def [](key)
      get_property(key)
      values[key] || (raise MissingProperty,
        "#{key} is not required and has not been set!")
    end

    def delete(name)
      unless get_property(name).required?
        values.delete(name)
      else
        raise MissingProperty, "You can't delete required property #{name}!"
      end
    end

    protected
    attr_reader :config_props, :values

    def values
      @values ||= Hash.new
    end

    def validate_type!(value, property)
      unless value.is_a?(property.type)
        raise InvalidProperty,
          "Property #{property.name} should be a #{property.type}"
      end
    end

    def get_property(name)
      property = config_props.find{|p| p.name == name}
      return property ||
        (raise UndefinedProperty, "#{name} is not a valid property!")
    end

    def validate_required_present!
      config_props.select{|p| p.required?}.each do |property|
        values.fetch(property.name) do
          raise MissingProperty, "Property #{property.name} is required!"
        end
      end
    end

    def extra_property_message(extra_property_names)
      if extra_property_names.length > 1
        "#{extra_property_names} are not recognized property names!"
      else
        "#{extra_property_names.first} is not a valid property name!"
      end
    end
  end
end
