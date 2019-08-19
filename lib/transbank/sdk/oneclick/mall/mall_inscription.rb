module Transbank
  module Webpay
    module Oneclick
      class MallInscription
        extend Transbank::Utils::NetHelper
        
        INSCRIPTION_START_ENDPOINT = 'rswebpaytransaction/api/oneclick/v1.0/inscriptions'.freeze
        INSCRIPTION_FINISH_ENDPOINT = 'rswebpaytransaction/api/oneclick/v1.0/inscriptions/:token'.freeze
        INSCRIPTION_DELETE_ENDPOINT = 'rswebpaytransaction/api/oneclick/v1.0/inscriptions'.freeze
        class << self
          def start(user_name:, email:, response_url:, options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? Oneclick::Base::integration_type[:TEST] : Oneclick::Base.integration_type_url(integration_type)

            url = base_url + INSCRIPTION_START_ENDPOINT
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)

            body = {
              user_name: user_name,
              email: email,
              response_url: response_url
            }
            resp = http_post(uri_string: url, body: body, headers: headers, camel_case_keys: false)
            body = JSON.parse(resp.body)
            return ::Transbank::Webpay::Oneclick::MallInscriptionStartResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Oneclick::Errors::MallInscriptionStartError.new(body['error_message'], resp.code)
          end

          def finish(token:, options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? Oneclick::Base::integration_type[:TEST] : Oneclick::Base.integration_type_url(integration_type)

            url = base_url + INSCRIPTION_FINISH_ENDPOINT
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)

            resp = http_put(uri_string: url, headers: headers)
            body = JSON.parse(resp.body)
            return ::Transbank::Webpay::Oneclick::MallInscriptionFinishResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Oneclick::Errors::MallInscriptionFinishError.new(body['error_message'], resp.code)
          end

          def delete(tbk_user:, user_name:, options: nil)

            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? Oneclick::Base::integration_type[:TEST] : Oneclick::Base.integration_type_url(integration_type)

            url = base_url + INSCRIPTION_DELETE_ENDPOINT.gsub(':token', token)
            headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
            body = {tbk_user: tbk_user, user_name: user_name}
            resp = http_delete(uri_string: url, body: body, headers: headers)
            body = JSON.parse(resp.body)
            return ::Transbank::Webpay::Oneclick::MallInscriptionDeleteResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Oneclick::Errors::MallInscriptionDeleteError.new(body['error_message'], resp.code)
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