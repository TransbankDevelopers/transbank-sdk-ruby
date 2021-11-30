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
          integration: 'https://pagoautomaticocontarjetasint.transbank.cl'
        }
    
        def initialize(commerce_code = ::Transbank::Common::IntegrationCommerceCodes::PATPASS_COMERCIO, api_key = ::Transbank::Common::IntegrationApiKeys::PATPASS_COMERCIO, environment = DEFAULT_ENVIRONMENT)
          super
        end
    
        def start(url, name, lastName, secondLastName, rut, serviceId, finalUrl, maxAmount, phone, cellPhone, patpassName, personEmail, commerceEmail, address, city)
          request_service = ::Transbank::Shared::RequestService.new(
            ENVIRONMENTS[@environment] + START_ENDPOINT, @commerce_code, @api_key
          )
          request_service.post({
              url: url,
              nombre: name,
              pApellido: lastName,
              sApellido: secondLastName,
              rut: rut,
              serviceId: serviceId,
              finalUrl: finalUrl,
              commerceCode: @commerce_code,
              montoMaximo: maxAmount,
              telefonoFijo: phone,
              telefonoCelular: cellPhone,
              nombrePatPass: patpassName,
              correoPersona: personEmail,
              correoComercio: commerceEmail,
              direccion: address,
              ciudad: city
          })
        end

        def status(token)
          request_service = ::Transbank::Shared::RequestService.new(
            ENVIRONMENTS[@environment] + format(STATUS_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.post({token: token})
        end
    
      end
    end
  end
end