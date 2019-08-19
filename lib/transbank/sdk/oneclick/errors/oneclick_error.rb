module Transbank
  module Webpay
    module Oneclick
      module Errors
        class OneclickError < StandardError
          attr_accessor :code, :message
          def initialize(message, code)
            @code = code
            @message = message
            super(message)
          end
        end
      end
    end
  end
end