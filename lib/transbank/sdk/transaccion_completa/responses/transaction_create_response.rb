module Transbank
  module TransaccionCompleta
    class TransactionCreateResponse
      attr_accessor :token
      def initialize(json)
        @token = json['token']
      end
    end
  end
end