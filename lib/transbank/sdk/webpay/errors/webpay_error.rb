module Transbank
  module Webpay
    module Errors
      class WebpayError < StandardError
        attr_accessor :message, :code
        def initialize(message:, code:)
          self.message = message
          self.code = code
        end
      end
    end
  end
end