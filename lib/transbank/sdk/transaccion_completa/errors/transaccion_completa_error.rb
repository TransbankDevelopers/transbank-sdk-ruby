module Transbank
  module TransaccionCompleta
    module Errors
      class TransaccionCompletaError < ::Transbank::Errors::TransbankError
        attr_accessor :code, :message

        def initialize(message, code = nil)
          @message = message
          @code = code
          super(message)
        end

      end
    end
  end
end