module Transbank
  module Patpass
    module PatpassComercio
      class Inscription
        extend Utils::NetHelper

        START_INSCRIPTION_ENDPOINT = 'restpatpass/v1/services/patInscription'.freeze
        INSCRIPTION_STATUS_ENDPOINT = 'restpatpass/v1/services/status'.freeze


        FIELDS = %i(
          url name first_last_name second_last_name rut service_id final_url max_amount
          phone_number mobile_number patpass_name person_email commerce_email address city
        )

        class << self
          def start(url:, name:, first_last_name:, second_last_name:, rut:, service_id:, final_url:, max_amount:,
            phone_number:, mobile_number:, patpass_name:, person_email:, commerce_email:, address:, city:, options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? PatpassComercio::Base::integration_types[:TEST] : PatpassComercio::Base.integration_type_url(integration_type)

            body = {
                url: url,
                nombre: name,
                pApellido: first_last_name,
                sApellido: second_last_name,
                rut: rut,
                serviceId: service_id,
                finalUrl: final_url,
                commerceCode: commerce_code,
                montoMaximo: max_amount,
                telefonoFijo: phone_number,
                telefonoCelular: mobile_number,
                nombrePatPass: patpass_name,
                correoPersona: person_email,
                correoComercio: commerce_email,
                direccion: address,
                ciudad: city
            }
            url = base_url + START_INSCRIPTION_ENDPOINT
            headers = patpass_comercio_headers(commerce_code: commerce_code, api_key: api_key)
            resp = http_post(uri_string: url, body: body, headers: headers, camel_case_keys: false)
            body = JSON.parse(resp.body)
            return ::Transbank::Patpass::PatpassComercio::InscriptionStartResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            binding.pry
            raise Errors::InscriptionStartError.new(body['error_message'], resp.code)
          end

          def status(token: ,options: nil)
            api_key = options&.api_key || default_integration_params[:api_key]
            commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
            integration_type = options&.integration_type || default_integration_params[:integration_type]
            base_url = integration_type.nil? ? PatpassComercio::Base::integration_types[:TEST] : PatpassComercio::Base.integration_type_url(integration_type)

            body = {
               token: token
            }
            url = base_url + INSCRIPTION_STATUS_ENDPOINT
            headers = patpass_comercio_headers(commerce_code: commerce_code, api_key: api_key)
            resp = http_post(uri_string: url, body: body, headers: headers, camel_case_keys: false)
            body = JSON.parse(resp.body)
            return ::Transbank::Patpass::PatpassComercio::InscriptionStatusResponse.new(body) if resp.kind_of? Net::HTTPSuccess
            raise Errors::InscriptionStatusError.new(body['error_message'], resp.code)
          end

          def default_integration_params
            {
                api_key: Patpass::PatpassComercio::Base::DEFAULT_API_KEY,
                commerce_code: Patpass::PatpassComercio::Base::DEFAULT_COMMERCE_CODE,
                integration_type: Patpass::PatpassComercio::Base::integration_type,
                base_url: Patpass::PatpassComercio::Base::current_integration_type_url
            }
          end






        end




      end
    end
  end
end