require 'transbank/sdk/onepay/requests/request'
require 'transbank/sdk/onepay/errors/transaction_commit_error'

module Transbank
  module Onepay
    class TransactionCommitRequest
      include Request
      attr_reader :occ
      attr_reader :external_unique_number
      attr_reader :issued_at
      attr_accessor :signature

      SIGNATURE_PARAMS = [:occ,
                          :external_unique_number,
                          :issued_at].freeze
      # @param occ [String] Merchant purchase order
      # @param external_unique_number [String] a unique value (per Merchant, not global) that is used to identify a Transaction
      # @param issued_at [Integer] timestamp for when the transaction commit request was created
      def initialize(occ, external_unique_number, issued_at)
        self.occ = occ
        self.external_unique_number = external_unique_number
        @issued_at = issued_at
        @signature = nil
      end

      # @param occ [String] Merchant purchase order
      def occ=(occ)
        raise Errors::TransactionCommitError, 'occ cannot be null.' if occ.nil?
        @occ = occ
      end

      # @param external_unique_number [String] a unique value (per Merchant, not global) that is used to identify a Transaction
      def external_unique_number=(external_unique_number)
        raise Errors::TransactionCommitError, 'external_unique_number cannot be null.' if external_unique_number.nil?
        @external_unique_number = external_unique_number
      end

      # @param issued_at [Integer] timestamp for when the transaction commit request was created
      def issued_at=(issued_at)
        raise Errors::TransactionCommitError, 'issued_at cannot be null.' if issued_at.nil?
        @issued_at = issued_at
      end

      def sign(secret)
        self.signature = signature_for(to_data, secret)
        self
      end

    end
  end
end
