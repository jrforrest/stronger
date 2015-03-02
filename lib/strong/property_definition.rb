module Stronger
  module PropertyDefinition
    module ClassMethods
      def properties
        @properties ||= Array.new
      end

      def property_names
        properties.map(&:name)
      end

      def property(*names, **opts)
        new_props = names.map {|name| Property.new(name, **opts) }
        properties.concat(new_props)
        new_props.each{|p| expose_property(p) unless opts.delete(:private)}
      end

      private

      def expose_property(property)
        define_property_method(property.name) do |properties|
          properties[property.name]
        end

        define_property_method("#{property.name}=") do |properties, value|
          properties[property.name] = value
        end
      end

      # Defines a method by the given name using a given block, to which
      # the properties on the instance on which the method was called
      # will be yielded as the first argument, and the arguments given to
      # the called method as the rest of the arguments.  PropertyErrors
      # raised due to operations on the yielded properties will be rescued
      # and re-raised with their stack trace origin set to the defined method.
      def define_property_method(name, &blk)
        define_method(name) do |*args|
          begin
            blk.call(properties, *args)
          rescue PropertyError => e
            e.set_backtrace caller
            raise e
          end
        end
      end
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    def initialize(**property_values)
      set_properties(property_values)
    rescue PropertyError => e
      e.set_backtrace caller
      raise e
    end

    private
    attr_reader :properties

    def set_properties(values)
      @properties = PropertySet.new(values, self.class.properties)
    rescue PropertyError => e
      raise e
    end
  end
end
