module Transbank
  module Webpay
    module Errors
      class WebpayError < StandardError
        attr_accessor :message, :code
        def initialize(message, code)
          self.message = message
          self.code = code
          super(message)
        end
      end
    end
  end
end