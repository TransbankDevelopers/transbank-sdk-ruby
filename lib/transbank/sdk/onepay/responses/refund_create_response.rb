require 'transbank/sdk/onepay/responses/response'
require 'transbank/sdk/onepay/utils/jsonify'
require 'transbank/sdk/onepay/errors/response_error'
require 'json'

module Transbank
  module Onepay
    class RefundCreateResponse
      include Response, Utils::JSONifier
      attr_accessor :occ
      attr_accessor :external_unique_number
      attr_accessor :reverse_code
      attr_accessor :issued_at
      attr_accessor :signature

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
        self.external_unique_number = result['externalUniqueNumber']
        self.reverse_code = result['reverseCode']
        self.issued_at = result['issuedAt']
        self.signature = result['signature']
        self
      end
    end
  end
end
