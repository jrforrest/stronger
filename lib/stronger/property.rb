module Stronger
  class Property
    attr_reader :name, :type
    def initialize(name, type:, required: true)
      @name, @type, @required = name, type, required
    end

    def required?
      !!required
    end

    def typed?
      !type.nil?
    end

    private
    attr_reader :required
  end
end
