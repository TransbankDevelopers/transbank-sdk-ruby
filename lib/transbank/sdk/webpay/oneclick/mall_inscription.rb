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
          
          Transbank::Common::Validation.has_text_with_max_length(username, Transbank::Common::ApiConstants::USER_NAME_LENGTH, "username")
          Transbank::Common::Validation.has_text_with_max_length(email, Transbank::Common::ApiConstants::EMAIL_LENGTH, "email")
          Transbank::Common::Validation.has_text_with_max_length(response_url, Transbank::Common::ApiConstants::RETURN_URL_LENGTH, "response_url")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, START_ENDPOINT, @commerce_code, @api_key
          )
          request_service.post({
            username: username, email: email, response_url: response_url
                               })
        end

        def finish(token)

          Transbank::Common::Validation.has_text_with_max_length(token, Transbank::Common::ApiConstants::TOKEN_LENGTH, "token")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(FINISH_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put({})
        end 

        def delete(tbk_user, username)

          Transbank::Common::Validation.has_text_with_max_length(tbk_user, Transbank::Common::ApiConstants::TBK_USER_LENGTH, "tbk_user")
          Transbank::Common::Validation.has_text_with_max_length(username, Transbank::Common::ApiConstants::USER_NAME_LENGTH, "username")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, DELETE_ENDPOINT, @commerce_code, @api_key
          )
          request_service.delete({tbk_user: tbk_user, username: username})
        end  
      end  
    end
  end
end