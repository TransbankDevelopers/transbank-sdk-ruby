module Transbank
  module Webpay
    class Options
      attr_accessor :commerce_code, :api_key, :environment, :timeout

      def initialize(commerce_code, api_key, environment, timeout = ::Transbank::Common::ApiConstants::REQUEST_TIMEOUT)
        @commerce_code = commerce_code
        @api_key = api_key
        @environment = environment
        @timeout = timeout
      end
    end
  end
end
