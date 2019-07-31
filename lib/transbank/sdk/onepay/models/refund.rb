module Transbank
  module Onepay
    class Refund
      extend Transbank::Utils::NetHelper, Utils::RequestBuilder
      # Manages Refunds
      REFUND_TRANSACTION = 'nullifytransaction'.freeze
      TRANSACTION_BASE_PATH = '/ewallet-plugin-api-services/services/transactionservice/'.freeze

      class << self
        # Create a request for a Refund
        # @param amount [Integer] Amount to be refunded. Must be the full amount of the
        # [Transaction] to be refunded
        # @param occ [String] Merchant purchase order
        # @param external_unique_number [String] Unique identifier (per Merchant) of the [Transaction] that
        # will be refunded
        # @param authorization_code [String] Authorization code. This is given when the [Transaction]
        # is successfully committed (with the #commit method of [Transaction])
        # @param options[Hash, nil] an optional Hash with configuration overrides
        # @raise [RefundCreateError] if the response is nil or has no response code
        # @raise [RefundCreateError] if response from the service is not equal to 'OK'
        def create(amount:, occ:, external_unique_number:, authorization_code:, options: nil)
          refund_request = refund_transaction(refund_amount: amount,
                                              occ: occ,
                                              external_unique_number: external_unique_number,
                                              authorization_code: authorization_code,
                                              options: options)
          response = http_post(uri_string: refund_path, body: refund_request.to_h)

          if response.nil? || !response['responseCode']
            raise Errors::RefundCreateError, 'Could not obtain a response from the service.'
          end

          refund_create_response = RefundCreateResponse.new(response)

          unless refund_create_response.response_ok?
            raise Errors::RefundCreateError, refund_create_response.full_description
          end

          refund_create_response
        end

        # Return the string url to POST to
        # @return [String] the url to POST to
        def refund_path
          Base.current_integration_type_url + TRANSACTION_BASE_PATH + REFUND_TRANSACTION
        end
      end

    end
  end
end
