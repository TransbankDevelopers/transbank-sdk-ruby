module Transbank
  module Onepay
    module Utils
      # Utils for creating signatures, included on classes that need to be signed
      module SignatureUtils
        # Transform the instance of the class that calls this method into a
        # string in the format required for the signature, using the params defined
        # in the class' SIGNATURE_PARAMS array constant
        # @raise [RuntimeError] if self.class::SIGNATURE_PARAMS is nil or empty
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

        # Digest data and secret, creating a hashed string
        # @param data [String] a string created from the signable, created using #to_data
        # @param secret [String] the string to hash the data with.
        # @return [String] the result of the hashing of data with secret.
        def hmac_sha256(data, secret)
          OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret, data)
        end

        # Return the base64 of the hmac_sha256'd data & secret
        # @param data [String] a string created from the signable, created using #to_data
        # @param secret [String] the string to hash the data with.
        # @return [String] Base64 representation of the hmac_sha256 hashing of data & secret
        def signature_for(data, secret)
          Base64.encode64(hmac_sha256(data, secret)).strip
        end

        # Compare the @signature of self with the one recreated from self using
        # the secret param. Return true if equal
        # @param secret [String] the secret used to create the signature with.
        # @return [boolean] return true if signatures match
        # @raise [SignatureError] if signatures do not match.
        def validate_signature!(secret)
          given_signature = self.signature
          # We should be able to recreate the same signature from the signable's data
          # and the secret
          recalculated_signature = signature_for(self.to_data, secret)
          given_signature == recalculated_signature
        end
      end
    end
  end
end
