require 'transbank/sdk/onepay/utils/jsonify'
require 'transbank/sdk/onepay/models/options'
require 'transbank/sdk/onepay/errors/invalid_options_error'

# TODO: Document

module Transbank
  module Onepay
    module Request
      include Utils::JSONifier
      attr_accessor :api_key
      attr_accessor :app_key

      def set_keys_from_options(options)
        unless options.is_a? Options
          raise InvalidOptionsError('Options parameter is not of class "Options"')
        end
        self.app_key = options.app_key
        self.api_key = options.api_key
      end
    end
  end
end
