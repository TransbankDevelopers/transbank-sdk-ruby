module Transbank
  module Webpay
    module WebpayPlus
      class DeferredTransaction
        extend Transbank::Utils::NetHelper
        CREATE_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions'
        COMMIT_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions'
        TRANSACTION_STATUS_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions'
        REFUND_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions/:token/refunds'
        TRANSACTION_CAPTURE_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions/:token/capture'
        class << self

          def create(buy_order:, session_id:, amount:, return_url:, options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? WebpayPlus::Base::integration_type[:TEST] : WebpayPlus::Base.integration_type_url(integration_type)

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

          def commit(token:, options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? WebpayPlus::Base::integration_type[:TEST] : WebpayPlus::Base.integration_type_url(integration_type)

            url = base_url + COMMIT_TRANSACTION_ENDPOINT + "/#{token}"
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)

            resp = http_put(uri_string: url, body: nil, headers: headers)
            body = JSON.parse(resp.body)
            return ::Transbank::Webpay::WebpayPlus::TransactionCommitResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Errors::TransactionCommitError.new(body['error_message'], resp.code)
          end

          def refund(token:, amount:, options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? WebpayPlus::Base::integration_type[:TEST] : WebpayPlus::Base.integration_type_url(integration_type)

            url = base_url + REFUND_TRANSACTION_ENDPOINT.gsub(':token', token)
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
            body = {amount: amount}
            resp = http_post(uri_string: url, body: body, headers: headers)
            body = JSON.parse(resp.body)
            return ::Transbank::Webpay::WebpayPlus::TransactionRefundResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Errors::TransactionRefundError.new(body['error_message'], resp.code)
          end

          def status(token:, options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? WebpayPlus::Base::integration_type[:TEST] : WebpayPlus::Base.integration_type_url(integration_type)

            url = base_url + "#{TRANSACTION_STATUS_ENDPOINT}/#{token}"
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
            resp = http_get(uri_string: url, headers: headers)
            body = JSON.parse(resp.body)
            return ::Transbank::Webpay::WebpayPlus::TransactionStatusResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Errors::TransactionStatusError.new(body['error_message'], resp.code)
          end

          def capture(token:, buy_order:, authorization_code:, capture_amount:, options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? WebpayPlus::Base::integration_type[:TEST] : WebpayPlus::Base.integration_type_url(integration_type)

            url = base_url + TRANSACTION_CAPTURE_ENDPOINT.gsub(':token', token)
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
            body = {
              buy_order: buy_order,
              authorization_code: authorization_code,
              capture_amount: capture_amount
            }
            resp = http_put(uri_string: url, body: body, headers: headers)
            body = JSON.parse(resp.body)
            return ::Transbank::Webpay::WebpayPlus::TransactionCaptureResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Errors::TransactionCaptureError.new(body['error_message'], resp.code)
          end

          def default_integration_params
            {
              api_key: WebpayPlus::Base.api_key,
              commerce_code: WebpayPlus::Base::commerce_code,
              integration_type: WebpayPlus::Base::integration_type,
              base_url: WebpayPlus::Base::current_integration_type_url
            }
          end
        end
      end
    end
  end
end

