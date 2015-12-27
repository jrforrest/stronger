module Stronger
  class Interface
    attr_reader :methods
    def initialize(*methods)
      @methods = methods
    end
  end
end
