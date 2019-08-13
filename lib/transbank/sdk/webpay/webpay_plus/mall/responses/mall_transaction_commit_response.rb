module Transbank
  module Webpay
    module WebpayPlus
      class MallTransactionCommitResponse
        FIELDS = [
          :vci,
          :details,
          :buy_order,
          :session_id,
          :card_detail,
          :accounting_date,
          :transaction_date
        ]
        attr_accessor *FIELDS

        def initialize(json)
          FIELDS.each { |field| send("#{field}=", json["#{field}"])}
        end
      end
    end
  end
end

