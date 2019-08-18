module Transbank
  module Utils
    module NetHelper
      def http_get(uri_string:, headers:nil)
        uri = URI.parse(uri_string)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'
        request_headers = {'Content-Type' => 'application/json'}.merge(headers || {})
        request = Net::HTTP::Get.new(uri.path, request_headers)
        http.request(request)
      end
      # POST a request to Transbank's servers, and return the parsed response
      # @param uri_string [String] an URI to post to
      # @param body [Hash] the body of your POST request
      # @return [Hash] the JSON.parse'd response body
      def http_post(uri_string:, body: nil, headers: nil, camel_case_keys: true)
        uri = URI.parse(uri_string)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'

        request_headers = {'Content-Type' => 'application/json'}.merge(headers || {})
        request = Net::HTTP::Post.new(uri.path, request_headers)
        sendable_body = camel_case_keys ? keys_to_camel_case(body) : body
        request.body = JSON.generate(sendable_body)
        http.request(request)
      end

      def http_put(uri_string:, body: nil, headers: nil)
        uri = URI.parse(uri_string)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'

        request_headers = {'Content-Type' => 'application/json'}.merge(headers || {})
        request = Net::HTTP::Put.new(uri.path, request_headers)
        request.body = JSON.generate(body)
        http.request(request)
      end

      def http_delete(uri_string:, body: nil, headers: nil)
        uri = URI.parse(uri_string)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'

        request_headers = {'Content-Type' => 'application/json'}.merge(headers || {})
        request = Net::HTTP::Delete.new(uri.path, request_headers)
        request.body = JSON.generate(body)
        http.request(request)
      end

      # Required for sending data to Transbank on Onepay.
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

      def webpay_headers(commerce_code:, api_key:)
        {
          "Tbk-Api-Key-Id" => commerce_code,
          "Tbk-Api-Key-Secret" => api_key
        }
      end

    end
  end
end
