module Transbank
  module TransaccionCompleta
    class MallTransactionInstallmentsResponse

      attr_accessor :value
      def initialize(responses)
        @value = responses
      end
    end
  end
end