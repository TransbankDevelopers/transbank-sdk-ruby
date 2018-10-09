require 'transbank/sdk/onepay/responses/response'
require 'json'
require 'transbank/sdk/onepay/errors/response_error'

module Transbank
  module Onepay
    class TransactionCommitResponse
      include Response

      attr_accessor :occ, :authorization_code, :signature, :transaction_desc,
                    :buy_order, :issued_at, :amount, :installments_amount,
                    :installments_number

      SIGNATURE_PARAMS = [:occ,
                          :authorization_code,
                          :issued_at,
                          :amount,
                          :installments_amount,
                          :installments_number,
                          :buy_order].freeze
      def initialize(json)
        result = json.fetch('result')
        @response_code = json.fetch('responseCode')
        @description = json.fetch('description')
        @occ = result.fetch('occ')
        @authorization_code = result.fetch('authorizationCode')
        @signature = result.fetch('signature')
        @transaction_desc = result.fetch('transactionDesc')
        @buy_order = result.fetch('buyOrder')
        @issued_at = result.fetch('issuedAt')
        @amount = result.fetch('amount')
        @installments_amount = result.fetch('installmentsAmount')
        @installments_number = result.fetch('installmentsNumber')
      end

      def sign(secret)
        @signature = signature_for(to_data, secret)
      end
    end
  end
end
