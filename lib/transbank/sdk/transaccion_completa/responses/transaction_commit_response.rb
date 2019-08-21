module Transbank
  module TransaccionCompleta
    class TransactionCommitResponse
      FIELDS = %i(
                  vci amount status buy_order session_id card_number
                  accounting_date transaction_date authorization_code
                  payment_type_code response_code installments_number
                  installments_amount balance
                  )
      attr_accessor *FIELDS
      def initialize(json)
        FIELDS.each { |field| send("#{field}=", json["#{field}"])}
      end
    end
  end
end