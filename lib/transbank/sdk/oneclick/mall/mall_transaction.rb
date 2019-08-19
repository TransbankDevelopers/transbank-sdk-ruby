module Transbank
  module Webpay
    module Oneclick
      class MallTransaction
        extend Transbank::Utils::NetHelper

        AUTHORIZE_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/oneclick/v1.0/transactions'.freeze
        TRANSACTION_STATUS_ENDPOINT = 'rswebpaytransaction/api/oneclick/v1.0/transactions/:buy_order'.freeze
        TRANSACTION_REFUND_ENDPOINT = 'rswebpaytransaction/api/oneclick/v1.0/transactions/:buy_order/refunds'.freeze

        class << self

          def authorize(username:, tbk_user:, parent_buy_order:, details:,
                        options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? Oneclick::Base::integration_type[:TEST] : Oneclick::Base.integration_type_url(integration_type)

            url = base_url + AUTHORIZE_TRANSACTION_ENDPOINT
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)

            details_array = details.map do |det|
              hash = det.reduce({}) do |acc, (k, v)|
                acc[k.to_s] = v
                acc
              end
              # We need to make sure the hash's keys are strings (or symbols)
              # since Ruby doesnt have hahes with indifferent access
              # I chose to make them strings
              details_hash = {}
              details_hash[:amount] = hash.fetch('amount')
              details_hash[:buy_order] = hash.fetch('buy_order')
              details_hash[:commerce_code] = hash.fetch('commerce_code')
              details_hash[:installments_number] = hash.fetch('installments_number')
              details_hash
            end

            body = {
              username: username,
              tbk_user: tbk_user,
              buy_order: parent_buy_order,
              details: details_array
            }
            resp = http_post(uri_string: url, body: body, headers: headers, camel_case_keys: false)
            body = JSON.parse(resp.body)
            return ::Transbank::Webpay::Oneclick::MallTransactionAuthorizeResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Oneclick::Errors::MallTransactionAuthorizeError.new(body['error_message'], resp.code)
          end

          def status(buy_order:, options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? Oneclick::Base::integration_type[:TEST] : Oneclick::Base.integration_type_url(integration_type)

            url = base_url + TRANSACTION_STATUS_ENDPOINT.gsub(':buy_order', buy_order)
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
            resp = http_get(uri_string: url, headers: headers)
            body = JSON.parse(resp.body)
            return ::Transbank::Webpay::Oneclick::MallTransactionStatusResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Oneclick::Errors::MallTransactionStatusError.new(body['error_message'], resp.code)
          end

          def refund(buy_order:, child_commerce_code:, child_buy_order:, amount:,
                     options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? Oneclick::Base::integration_type[:TEST] : Oneclick::Base.integration_type_url(integration_type)

            url = base_url + TRANSACTION_REFUND_ENDPOINT.gsub(':buy_order', buy_order)
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
            body = {
              detail_buy_order: child_buy_order,
              commerce_code: child_commerce_code,
              amount: amount
            }
            resp = http_post(uri_string: url, body: body, headers: headers, camel_case_keys: false)
            body = JSON.parse(resp.body)
            return ::Transbank::Webpay::Oneclick::MallTransactionRefundResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Oneclick::Errors::MallTransactionRefundError.new(body['error_message'], resp.code)
          end

          def default_integration_params
            {
              api_key: Oneclick::Base::DEFAULT_API_KEY,
              commerce_code: Oneclick::Base::DEFAULT_ONECLICK_MALL_COMMERCE_CODE,
              integration_type: Oneclick::Base::integration_type,
              base_url: Oneclick::Base::current_integration_type_url
            }
          end
        end
      end
    end
  end
end