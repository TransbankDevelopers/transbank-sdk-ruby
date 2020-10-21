module Transbank
  module Webpay
    module Oneclick
      class MallDeferredTransaction < Transbank::Webpay::Oneclick::MallTransaction
        extend Transbank::Utils::NetHelper
        TRANSACTION_CAPTURE_ENDPOINT = 'rswebpaytransaction/api/oneclick/v1.0/transactions/capture'.freeze

        class << self

          def capture(child_commerce_code:, child_buy_order:, authorization_code:, amount:, options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? Oneclick::Base::integration_type[:TEST] : Oneclick::Base.integration_type_url(integration_type)

            url = base_url + TRANSACTION_CAPTURE_ENDPOINT
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
            body = {
              commerce_code: child_commerce_code,
              buy_order: child_buy_order,
              authorization_code: authorization_code,
              capture_amount: amount
            }
            resp = http_put(uri_string: url, headers: headers, body: body)
            body = JSON.parse(resp.body)
            return ::Transbank::Webpay::Oneclick::MallDeferredTransactionCaptureResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Oneclick::Errors::Oneclick::MallDeferredTransactionCaptureError.new(body['error_message'], resp.code)
          end

          def default_integration_params
            {
              api_key: Oneclick::Base::DEFAULT_API_KEY,
              commerce_code: Oneclick::Base::DEFAULT_ONECLICK_MALL_DEFERRED_COMMERCE_CODE,
              integration_type: Oneclick::Base::integration_type,
              base_url: Oneclick::Base::current_integration_type_url
            }
          end
        end
      end
    end
  end
end
