module Transbank
  module Onepay
    # Base module with methods & attributes common to Requests
    module Request
      include Transbank::Utils::JSONUtils, Utils::SignatureUtils
      attr_accessor :api_key
      attr_accessor :app_key

      # Set the request's @api_key overriding the one in
      # the [Base] class
      def set_keys_from_options(options)
        transform_hash_keys(options)
        new_api_key = options.fetch(:api_key, nil)
        self.api_key = new_api_key unless new_api_key.nil?
      end
    end
  end
end
