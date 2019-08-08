module Transbank
  module Patpass
    module PatpassByWebpay
      class Transaction
        extend Transbank::Utils::NetHelper
        CREATE_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions'
        COMMIT_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions'
        TRANSACTION_STATUS_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions'

        class << self

          def create(buy_order:, session_id:, amount:, return_url:, details: ,options: nil)

            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? PatpassByWebpay::Base::integration_types[:TEST] : PatpassByWebpay::Base.integration_type_url(integration_type)

            body = {
                buy_order: buy_order,
                session_id: session_id,
                amount: amount,
                return_url: return_url,
                wpm_detail: details
            }

            url = base_url + CREATE_TRANSACTION_ENDPOINT
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
            resp = http_post(uri_string: url, body: body, headers: headers, camel_case_keys: false)
            body = JSON.parse(resp.body)

            return ::Transbank::Patpass::PatpassByWebpay::TransactionCreateResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Errors::TransactionCreateError.new(body['error_message'], resp.code)
          end

          def commit(token:, options: nil)

            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:api_key]
            base_url = PatpassByWebpay::Base.integration_types[options&.integration_type] || default_integration_params[:base_url]

            url = base_url + COMMIT_TRANSACTION_ENDPOINT + "/#{token}"
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)

            resp = http_put(uri_string: url, body: nil, headers: headers)
            body = JSON.parse(resp.body)
            return ::Transbank::Patpass::PatpassByWebpay::TransactionCommitResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Errors::TransactionCommitError.new(body['error_message'], resp.code)
          end

          def status(token:, options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:api_key]
            base_url = PatpassByWebpay::Base.integration_types[options&.integration_type] || default_integration_params[:base_url]

            url = base_url + "#{TRANSACTION_STATUS_ENDPOINT}/#{token}"
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
            resp = http_get(uri_string: url, headers: headers)
            body = JSON.parse(resp.body)
            return ::Transbank::Patpass::PatpassByWebpay::TransactionStatusResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Errors::TransactionStatusError.new(body['error_message'], resp.code)
          end

          def default_integration_params
            {
                api_key: PatpassByWebpay::Base::DEFAULT_API_KEY,
                commerce_code: PatpassByWebpay::Base::DEFAULT_COMMERCE_CODE,
                base_url: PatpassByWebpay::Base::current_integration_type_url
            }
          end
        end
      end
    end
  end
end

