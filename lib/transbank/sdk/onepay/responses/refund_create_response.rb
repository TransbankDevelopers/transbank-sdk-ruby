module Transbank
  module Onepay
    # Serializes the response to a RefundCreateRequest
    class RefundCreateResponse
      include Response
      attr_accessor :occ, :external_unique_number, :reverse_code, :issued_at,
                    :signature
      # @raise []RefundCreateError] if the responseCode from the service is not 'OK'
      def initialize(json)
        unless json.fetch('responseCode').downcase == 'ok'
          raise Errors::RefundCreateError, "#{json.fetch('responseCode')} : #{json.fetch('description')}"
        end
        result = json.fetch('result')
        @response_code = json.fetch('responseCode')
        @description = json.fetch('description')
        @occ = result.fetch('occ')
        @external_unique_number = result.fetch('externalUniqueNumber')
        @reverse_code = result.fetch('reverseCode')
        @issued_at = result.fetch('issuedAt')
        @signature = result.fetch('signature')
      end
    end
  end
end
