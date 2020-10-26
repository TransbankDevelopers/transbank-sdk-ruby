module Transbank
  module Webpay
    module WebpayPlus
      class TransactionRefundResponse

        FIELDS =
          [:type, :authorize_code, :authorization_date, :nullified_amount,
          :balance, :response_code]

        attr_accessor *FIELDS

        def initialize(json)
          FIELDS.each {|field| send("#{field}=", json["#{field}"]) }
        end
      end
    end
  end
end

