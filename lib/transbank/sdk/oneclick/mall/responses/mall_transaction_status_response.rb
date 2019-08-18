module Transbank
  module Webpay
    module Oneclick
      class MallTransactionStatusResponse
        FIELDS = [:buy_order, :session_id, :card_details, :expiration_date,
                  :accounting_date, :transaction_date, :details]
        attr_accessor *FIELDS

        def initialize(json)
          FIELDS.each {|field| send("#{field}=", json["#{field}"]) }
        end
      end
    end
  end
end
