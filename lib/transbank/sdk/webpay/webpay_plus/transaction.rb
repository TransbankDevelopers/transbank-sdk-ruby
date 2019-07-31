module Transbank
  module Webpay
    module WebpayPlus
      class Transaction
        extend Transbank::Utils::NetHelper
        CREATE_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions';


        class << self

          def create(buy_order:, session_id:, amount:, return_url:, options: nil)
            if options.nil?
              api_key = default_integration_params[:api_key]
              commerce_code = default_integration_params[:commerce_code]
              base_url = default_integration_params[:base_url]
            else
              api_key = options.api_key
              commerce_code = options.commerce_code
              base_url = WebpayPlus::Base.integration_types[options.integration_type]
            end

            headers = headers(commerce_code, api_key)
            body = {
              buy_order: buy_order, session_id: session_id,
              amount: amount, return_url: return_url
            }
            url = base_url + CREATE_TRANSACTION_ENDPOINT
            response = http_post(uri_string: url, body: body)



          end

          def default_integration_params
            {
              api_key: WebpayPlus::Base::DEFAULT_API_KEY,
              commerce_code: WebpayPlus::Base::DEFAULT_COMMERCE_CODE,
              base_url: WebpayPlus::Base::integration_types[:TEST]
            }
          end

          def headers(commerce_code, api_key)
            {
              "Tbk-Api-Key-Id" => commerce_code,
              "Tbk-Api-Key-Secret" => api_key
            }
          end

        end

      end
    end
  end
end

