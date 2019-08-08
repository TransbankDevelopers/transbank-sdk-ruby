module Transbank
  module Webpay
    module Errors
      class IntegrationTypeError < ::Transbank::Errors::TransbankError
        attr_accessor :message, :code
        def initialize(message)
          self.message = message
          super(message)
        end
      end
    end
  end
end
