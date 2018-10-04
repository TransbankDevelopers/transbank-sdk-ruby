require 'transbank/sdk/onepay/responses/response'
require 'json'
require 'transbank/sdk/onepay/errors/response_error'

module Transbank
  module Onepay
    class TransactionCommitResponse
      include Response

      attr_accessor :occ
      attr_accessor :authorization_code
      attr_accessor :signature
      attr_accessor :transaction_desc
      attr_accessor :buy_order
      attr_accessor :issued_at
      attr_accessor :amount
      attr_accessor :installments_amount
      attr_accessor :installments_number

      SIGNATURE_PARAMS = [:occ,
                          :authorization_code,
                          :issued_at,
                          :amount,
                          :installments_amount,
                          :installments_number,
                          :buy_order].freeze

      def initialize(json)
        from_json json
      end

      def from_json(json)
        json = JSON.parse(json) if json.is_a? String
        unless json.is_a? Hash
          raise ResponseError('JSON must be a Hash (or a String decodeable to one).')
        end
        result = json['result']
        self.response_code = json['responseCode']
        self.description = json['description']
        self.occ = result['occ']
        self.authorization_code = result['authorizationCode']
        self.signature = result['signature']
        self.transaction_desc = result['transactionDesc']
        self.buy_order = result['buyOrder']
        self.issued_at = result['issuedAt']
        self.amount = result['amount']
        self.installments_amount = result['installmentsAmount']
        self.installments_number = result['installmentsNumber']
        self
      end

      def sign(secret)
        self.signature = signature_for(to_data, secret)
      end

    end
  end
end
