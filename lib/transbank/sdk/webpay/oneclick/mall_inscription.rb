module Transbank
  module Webpay
    module Oneclick
      class MallInscription < ::Transbank::Common::BaseTransaction
        DEFAULT_ENVIRONMENT = :integration
        RESOURCES_URL = ::Transbank::Common::ApiConstants::ONECLICK_ENDPOINT
        START_ENDPOINT = (RESOURCES_URL + '/inscriptions').freeze
        FINISH_ENDPOINT = (RESOURCES_URL + '/inscriptions/%{token}').freeze
        DELETE_ENDPOINT = (RESOURCES_URL + '/inscriptions').freeze
    
        def initialize(commerce_code = ::Transbank::Common::IntegrationCommerceCodes::ONECLICK_MALL, api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, environment = DEFAULT_ENVIRONMENT)
          super
        end
    
        def start(username, email, response_url)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, START_ENDPOINT, @commerce_code, @api_key
          )
          request_service.post({
            username: username, email: email, response_url: response_url
                               })
        end

        def finish(token)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(FINISH_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put({})
        end 

        def delete(tbk_user, username)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, DELETE_ENDPOINT, @commerce_code, @api_key
          )
          request_service.delete({tbk_user: tbk_user, username: username})
        end  
      end  
    end
  end
end