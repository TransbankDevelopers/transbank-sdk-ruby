module Transbank
  module Patpass
    module PatpassComercio
      class Inscription < ::Transbank::Common::BaseTransaction
        DEFAULT_ENVIRONMENT = :integration
        RESOURCES_URL = ::Transbank::Common::ApiConstants::PATPASS_ENDPOINT
        START_ENDPOINT = (RESOURCES_URL + '/patInscription').freeze
        STATUS_ENDPOINT = (RESOURCES_URL + '/status').freeze

        ENVIRONMENTS = {
          production: 'https://www.pagoautomaticocontarjetas.cl',
          integration: 'https://pagoautomaticocontarjetasint.transbank.cl/'
        }
    
        def initialize(commerce_code = ::Transbank::Common::IntegrationCommerceCodes::PATPASS_COMERCIO, api_key = ::Transbank::Common::IntegrationApiKeys::PATPASS_COMERCIO, environment = DEFAULT_ENVIRONMENT)
          super(commerce_code, api_key, environment)
        end
    
        def start(url, name, last_name, second_last_name, rut, service_id, final_url, max_amount, phone, cell_phone, patpass_name, person_email, commerce_email, address, city)
          request_service = ::Transbank::Shared::RequestService.new(
            ENVIRONMENTS[@environment] + START_ENDPOINT, @commerce_code, @api_key
          )
          request_service.set_patpass();
          request_service.post({
              url: url,
              nombre: name,
              pApellido: last_name,
              sApellido: second_last_name,
              rut: rut,
              serviceId: service_id,
              finalUrl: final_url,
              commerceCode: @commerce_code,
              montoMaximo: max_amount,
              telefonoFijo: phone,
              telefonoCelular: cell_phone,
              nombrePatPass: patpass_name,
              correoPersona: person_email,
              correoComercio: commerce_email,
              direccion: address,
              ciudad: city
          })
          
        end

        def status(token)
          request_service = ::Transbank::Shared::RequestService.new(
            ENVIRONMENTS[@environment] + format(STATUS_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.set_patpass();
          request_service.post({token: token})
        end
    
      end
    end
  end
end