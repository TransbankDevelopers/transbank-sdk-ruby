module Transbank
  module Shared
    class RequestService
      ENVIRONMENTS = {
        production: 'https://webpay3g.transbank.cl/',
        integration: 'https://webpay3gint.transbank.cl/'
      }

      def initialize(environment=nil, endpoint, commerce_code, api_key)
        @commerce_code = commerce_code
        @api_key = api_key
        if environment.nil?
          @url =  endpoint
        else
          @url = ENVIRONMENTS[environment] + endpoint
        end
        @headers = headers(@commerce_code, @api_key)
      end

      def set_patpass()
        @headers = headers_patpass(@commerce_code, @api_key)
      end

      def post(body)
        build_http_request('post', body)
      end

      def put(body)
        build_http_request('put', body)
      end

      def get
        build_http_request('get')
      end

      def delete(body)
        build_http_request('delete', body)
      end

      private

      def build_http_request(method, body = nil)
        # raise TransbankError, 'Transbank Error: Incorrect Request type' unless %w[put post].include?(method.downcase)

        uri, http = build_client
        http_method = build_method(method, uri, body)

        response = http.request(http_method)
        if response.is_a? Net::HTTPSuccess
          return nil if response.body.empty?
          return JSON.parse(response.body)
        end
        body = JSON.parse(response.body)
        if body.key?("description")
          raise TransbankError, "Transbank Error: #{body['code']} - #{body['description']}"
        else
          raise TransbankError, "Transbank Error: #{body['error_message']}"
        end
      end

      def build_client
        uri = URI.parse(@url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'
        [uri, http]
      end

      def build_method(method, uri, body = nil)
        http_method = Object.const_get("Net::HTTP::#{method.capitalize}").new(uri.path, @headers)
        if !body.nil?
          http_method.body = body.to_json
        end
        http_method
      end

      def headers(commerce_code, api_key)
        {
          'Tbk-Api-Key-Id' => commerce_code.to_s,
          'Tbk-Api-Key-Secret' => api_key,
          'Content-Type' => 'application/json'
        }
      end

      def headers_patpass(commerce_code, api_key)
        {
          'commercecode' => commerce_code.to_s,
          'Authorization' => api_key,
          'Content-Type' => 'application/json'
        }
      end
    end
  end
end
