module Manning
  module Docbook
    class Validator
      class Error
        attr_accessor :message
        def initialize(message)
          @message = message
        end
      end
    end
  end
end
