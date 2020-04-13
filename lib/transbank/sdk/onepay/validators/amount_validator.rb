module Transbank
  module Onepay
    module Validators
      class AmountValidator
        include Transbank::Onepay::Errors

        # @raise [InvalidAmountError] When amount is not numeric nor integer
        def self.validate(amount, nullable=false)
          if amount.nil? && nullable
            return
          end
          float_amount = Float(amount)
        rescue ArgumentError, TypeError
          raise InvalidAmountError, InvalidAmountError::NOT_NUMERIC_MESSAGE
        else
          if float_amount.floor != float_amount
            raise InvalidAmountError, InvalidAmountError::HAS_DECIMALS_MESSAGE
          end
        end
      end
    end
  end
end
