require 'openssl'
require 'base64'

module Transbank
  module Onepay
    module Utils
      module SignatureUtils
        def to_data
          if self.class::SIGNATURE_PARAMS.nil? || self.class::SIGNATURE_PARAMS.empty?
            raise RuntimeError, 'SIGNATURE_PARAMS is empty or nil!'
          end
          self.class::SIGNATURE_PARAMS.reduce('') do |data_string, current_value|
            value_of_getter = send(current_value)
            # Integer#digits is ruby 2.4 upwards :(
            data_string + value_of_getter.to_s.length.to_s + value_of_getter.to_s
          end
        end

        def hmac_sha256(data, secret)
          OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret, data)
        end

        def signature_for(data, secret)
          Base64.encode64(hmac_sha256(data, secret)).strip
        end

        def validate_signature!(secret)
          given_signature = self.signature
          # We should be able to recreate the same signature from the signable's data
          # and the secret
          recalculated_signature = signature_for(self.to_data, secret)
          signature_is_valid = given_signature == recalculated_signature
          unless signature_is_valid
            raise Errors::SignatureError, "The response's signature is not valid."
          end
          true
        end
      end
    end
  end
end
