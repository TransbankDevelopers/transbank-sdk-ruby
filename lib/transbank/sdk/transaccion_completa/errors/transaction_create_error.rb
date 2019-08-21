module Transbank
  module TransaccionCompleta
    module Errors
      class TransactionCreateError < TransaccionCompletaError
        attr_accessor :message, :code
        def initialize(message, code = nil)
          self.message = message
          self.code = code
          super(message)
        end
      end
    end
  end
end