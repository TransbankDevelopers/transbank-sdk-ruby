module Transbank
  module Webpay
    module WebpayPlus
      class TransactionCaptureResponse

        FIELDS =
          [:token,
           :authorization_code,
           :authorization_date,
           :captured_amount,
           :response_code]

        attr_accessor *FIELDS

        def initialize(json)
          FIELDS.each {|field| send("#{field}=", json["#{field}"]) }
        end
      end
    end
  end
end

