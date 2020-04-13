module Transbank
  module Onepay
    module Errors
      class InvalidAmountError < TransbankError
        DEFAULT_MESSAGE = 'Invalid amount given.'
        NOT_NUMERIC_MESSAGE = 'Given amount is not numeric.'
        HAS_DECIMALS_MESSAGE = 'Given amount has decimals. Webpay only accepts integer amounts. Please remove decimal places.'

        def initialize(msg=DEFAULT_MESSAGE)
          super
        end
      end
    end
  end
end
