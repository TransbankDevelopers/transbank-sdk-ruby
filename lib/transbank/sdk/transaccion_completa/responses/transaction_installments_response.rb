module Transbank
  module TransaccionCompleta
    class TransactionInstallmentsResponse
      attr_accessor :installments_amount, :id_query_installments,
                    :deferred_periods
      def initialize(json)
        @installments_amount = json['installments_amount']
        @id_query_installments = json['id_query_installments']
        @deferred_periods = json['deferred_periods']
      end
    end
  end
end