module Transbank
  module Webpay
    module Errors
      class IntegrationTypeError < WebpayError
        attr_accessor :message
        def initialize(message)
          self.message = message
          super(message)
        end
      end
    end
  end
end