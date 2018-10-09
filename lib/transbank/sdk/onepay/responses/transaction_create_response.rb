require 'transbank/sdk/onepay/responses/response'
require 'json'


module Transbank
  module Onepay
    # Serializes the response to a TransactionCreateRequest
    class TransactionCreateResponse
      include Response

      attr_accessor :occ, :ott, :external_unique_number, :qr_code_as_base64,
                    :issued_at, :signature

      SIGNATURE_PARAMS = [:occ,
                          :external_unique_number,
                          :issued_at].freeze
      # @raise [KeyError] upon trying to fetch a missing key from the response
      def initialize(json)
        result = json.fetch('result')
        @response_code = json.fetch('responseCode')
        @description = json.fetch('description')
        @occ = result.fetch('occ')
        @ott = result.fetch('ott')
        @external_unique_number = result.fetch('externalUniqueNumber')
        @qr_code_as_base64 = result.fetch('qrCodeAsBase64')
        @issued_at = result.fetch('issuedAt')
        @signature = result.fetch('signature')
      end

      def sign(secret)
        @signature = signature_for(to_data, secret)
        self
      end
    end
  end
end
