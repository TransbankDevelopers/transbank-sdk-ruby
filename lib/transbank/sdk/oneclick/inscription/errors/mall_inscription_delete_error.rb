module Transbank
  module Webpay
    module Oneclick
      class MallInscriptionDeleteError < OneclickError
        attr_accessor :code, :message
        def initialize(message, code)
          @code = code
          @message = message
          super(message, code)
        end
      end
    end
  end
end