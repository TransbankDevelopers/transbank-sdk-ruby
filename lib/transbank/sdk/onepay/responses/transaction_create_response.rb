require 'transbank/sdk/onepay/responses/response'
require 'json'
require 'transbank/sdk/onepay/utils/jsonify'


module Transbank
  module Onepay
    class TransactionCreateResponse
      include Response, Utils::JSONifier

      attr_accessor :occ
      attr_accessor :ott
      attr_accessor :external_unique_number
      attr_accessor :qr_code_as_base64
      attr_accessor :issued_at
      attr_accessor :signature

      def initialize(response_json)
        from_json response_json
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
        self.ott = result['ott']
        self.external_unique_number = result['externalUniqueNumber']
        self.qr_code_as_base64 = result['qrCodeAsBase64']
        self.issued_at = result['issuedAt']
        self.signature = result['signature']
        self
      end
    end
  end
end
