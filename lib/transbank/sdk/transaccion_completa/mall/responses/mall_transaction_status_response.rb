module Transbank
  module TransaccionCompleta
    class MallTransactionStatusResponse
      FIELDS = %i(
                  buy_order session_id card_detail expiration_date
                  accounting_date transaction_date details
                  )
      attr_accessor *FIELDS
      def initialize(json)
        FIELDS.each { |field| send("#{field}=", json["#{field}"])}
      end
    end
  end
end