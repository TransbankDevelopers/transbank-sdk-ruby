require 'transbank/sdk/onepay/utils/jsonify'
require 'transbank/sdk/onepay/models/options'
require 'transbank/sdk/onepay/errors/invalid_options_error'
require 'transbank/sdk/onepay/utils/signature_utils'
# TODO: Document
module Transbank
  module Onepay
    module Request
      include Utils::JSONifier, Utils::SignatureUtils
      attr_accessor :api_key
      attr_accessor :app_key

      def set_keys_from_options(options)
        self.transform_hash_keys(options)
        self.app_key = options[:app_key]
        self.api_key = options[:api_key]
      end
    end
  end
end
