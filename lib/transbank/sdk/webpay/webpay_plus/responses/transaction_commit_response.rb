module Transbank
  module Webpay
    module WebpayPlus
      class TransactionCommitResponse

        FIELDS =
          [:vci, :amount, :buy_order, :session_id,
           :card_number, :accounting_date, :transaction_date,
           :authorization_code, :payment_type_code, :response_code,
           :installments_amount, :installments_number, :balance]

        attr_accessor *FIELDS

        def initialize(json)
          fields = FIELDS - [:card_number]
          fields.each {|field| send("#{field}=", json["#{field}"]) }
          self.card_number = json['card_details']['card_number']
        end
      end
    end
  end
end
