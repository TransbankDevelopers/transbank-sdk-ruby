require 'transbank/sdk/onepay/requests/request'
require 'transbank/sdk/onepay/utils/json_utils'

module Transbank
  module Onepay
    # Creates a Refund request
    class RefundCreateRequest
      include Request
      attr_accessor :nullify_amount, :occ, :external_unique_number,
                    :authorization_code, :issued_at, :signature

      # These are the params used to build this class's @signature
      SIGNATURE_PARAMS = [:occ,
                          :external_unique_number,
                          :authorization_code,
                          :issued_at,
                          :nullify_amount].freeze

      # @param nullify_amount [Integer, nil] The total amount of the [Transaction] to Refund.
      # No partial refunds are possible
      # @param external_unique_number [String] a unique value (per Merchant, not global) that is used to identify a Transaction
      # @param occ [String] Merchant purchase order
      # @param authorization_code [String] a string returned when [Transaction]#commit completes correctly
      # @param issued_at [Integer, nil] a timestamp
      # @param signature [String, nil] a hashed string to verify the data
      def initialize(nullify_amount: nil,
                     occ: nil,
                     external_unique_number: nil,
                     authorization_code: nil,
                     issued_at: nil,
                     signature: nil)
        @nullify_amount = nullify_amount
        @occ = occ
        @external_unique_number = external_unique_number
        @authorization_code = authorization_code
        @issued_at = issued_at
        @signature = signature
      end

      # Create and set the signature for this instance of RefundCreateRequest
      # @return [RefundCreateRequest] returns self
      def sign(secret)
        @signature = signature_for(to_data, secret)
        self
      end
    end
  end
end
