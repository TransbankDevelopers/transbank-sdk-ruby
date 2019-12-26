module Transbank
  module Webpay
    module Errors
      class WebpayError < ::Transbank::Errors::TransbankError
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