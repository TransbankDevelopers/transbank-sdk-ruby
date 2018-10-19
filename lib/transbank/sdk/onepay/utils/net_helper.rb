module Transbank
  module Onepay
    module Utils
      module NetHelper
        # POST a request to Transbank's servers, and return the parsed response
        # @param uri_string [String] an URI to post to
        # @param body [Hash] the body of your POST request
        # @return [Hash] the JSON.parse'd response body
        def http_post(uri_string, body)
          uri = URI.parse(uri_string)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == 'https'
          request = Net::HTTP::Post.new(uri.path, 'Content-Type'=> 'application/json')
          camel_cased_body = keys_to_camel_case(body)
          request.body = JSON.generate(camel_cased_body)
          result = http.request(request)
          JSON.parse(result.body)
        end

        # Required for sending data to Transbank.
        def keys_to_camel_case(hash)
          hash.reduce({}) do |new_hash, (key, val)|
            if val.is_a? Array
              val = val.map {|value| value.is_a?(Hash) ? keys_to_camel_case(value) : value }
            end
            new_key = snake_to_camel_case(key.to_s)
            new_hash[new_key] = val
            new_hash
          end
        end

        def snake_to_camel_case(str)
          str.split('_').reduce { |string, current_word| string + current_word.capitalize }
        end
      end
    end
  end
end
