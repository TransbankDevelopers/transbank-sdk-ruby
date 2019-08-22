module Transbank
  module TransaccionCompleta
    class MallTransactionInstallmentsResponse

      attr_accessor :value
      def initialize(json)
        @value = json
      end
    end
  end
end