# TODO: Document


require '../../../lib/transbank/sdk/utils/net_helper'

class Refund
  # Manages Refunds
  REFUND_TRANSACTION = 'nullifytransaction'.freeze
  TRANSACTION_BASE_PATH = '/ewallet-plugin-api-services/services/transactionservice/'.freeze

  class << self
    # TODO: Complete this documentation
    # Create a request for a Refund
    # @param amount [Integer] Amount to be refunded. Must be the full amount of the
    # [Transaction] to be refunded
    # @param occ [String] Merchant purchase order
    # @param external_unique_number [String] Unique identifier (per Merchant) of the [Transaction] that
    # will be refunded
    # @param authorization_code [String] Authorization code. This is given when the [Transaction]
    # is successfully committed (with the #commit method of [Transaction])
    # @param options [Options, nil]
    def create(amount, occ, external_unique_number, authorization_code, options = nil)
      refund_request = RequestBuilder.refund_transaction(amount,
                                                         occ,
                                                         external_unique_number,
                                                         authorization_code,
                                                         options)

      response = NetHelper.post(refund_path, refund_request.jsonify)

      if response.nil? || !response['responseCode']
        raise RefundCreateException('Could not obtain a response from the service.')
      end

      refund_create_response = RefundCreateResponse.new(response)

      unless refund_create_response.response_ok?
        raise RefundCreateException(refund_create_response.full_description, -1)
      end

      refund_create_response
    end

    def refund_path
      Onepay.current_integration_type_url + TRANSACTION_BASE_PATH + REFUND_TRANSACTION
    end
  end

end