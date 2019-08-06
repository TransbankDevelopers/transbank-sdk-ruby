module Transbank
  module Patpass
    module PatpassByWebpay
      class Transaction
        extend Transbank::Utils::NetHelper
        CREATE_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions'
        COMMIT_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions'
        TRANSACTION_STATUS_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions'

        class << self

          def create(buy_order:, session_id:, amount:, return_url:, options: nil)
            api_key = default_integration_params[:api_key]
            commerce_code = default_integration_params[:commerce_code]
            base_url = default_integration_params[:base_url]
            unless options.nil?
              api_key = options.api_key || default_integration_params[:api_key]
              commerce_code = options.commerce_code || default_integration_params[:api_key]
              base_url = PatpassByWebpay::Base.integration_types[options.integration_type] || default_integration_params[:base_url]
            end

            body = {
                buy_order: buy_order, session_id: session_id,
                amount: amount, return_url: return_url
            }

            url = base_url + CREATE_TRANSACTION_ENDPOINT
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
            resp = http_post(uri_string: url, body: body, headers: headers, camel_case_keys: false)
            body = JSON.parse(resp.body)
            return ::Transbank::Webpay::WebpayPlus::TransactionCreateResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Errors::TransactionCreateError.new(body['error_message'], resp.code)
          end


          end
        end
      end
    end
  end
end

