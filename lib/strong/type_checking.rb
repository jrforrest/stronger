module Stronger
  module TypeChecking
    refine Object do
      def is_strong?(type)
        if type.is_a?(Interface)
          implements?(type)
        elsif type.is_a?(Class) or type.is_a?(Module)
          is_a?(type)
        else
          raise ArgumentError, "Don't know how to compare type of "\
            "#{self} against #{type}.  Try using a "\
            "Stronger::Interface, Class or Module"
        end
      end

      def implements?(interface)
        interface.methods.all?{|m| respond_to?(m) }
      end
    end

    module Implementers
      def <(type)
        if type.is_a?(Interface)
          instance_implements?(type)
        else
          super(type)
        end
      end

      def >(type)
        !(self <= type)
      end

      def instance_implements?(interface)
        (interface.methods - instance_methods).empty?
      end

      def implement(interface)
        interface.methods.each do |name|
          define_method(name) do
            raise NotImplementedError, "#{self.class} should implement #{name}!"
          end
        end
      end
    end

    refine Class do
      include Implementers
    end

    refine Module do
      include Implementers
    end
  end
end
