module Transbank
  module Webpay
    module TransaccionCompleta
      class MallTransaction < ::Transbank::Common::BaseTransaction
        DEFAULT_ENVIRONMENT = :integration
        RESOURCES_URL = ::Transbank::Common::ApiConstants::WEBPAY_ENDPOINT
        CREATE_ENDPOINT = (RESOURCES_URL + '/transactions/').freeze
        INSTALLMENTS_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/installments').freeze
        COMMIT_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}').freeze
        STATUS_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}').freeze
        REFUND_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/refunds').freeze
        CAPTURE_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/capture').freeze
    
        def initialize(commerce_code = ::Transbank::Common::IntegrationCommerceCodes::TRANSACCION_COMPLETA_MALL, api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, environment = DEFAULT_ENVIRONMENT)
          super
        end

        def create(buy_order, session_id, card_number, card_expiration_date, details, cvv = nil)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, CREATE_ENDPOINT, @commerce_code, @api_key
          )
          request_service.post({
                                 buy_order: buy_order, session_id: session_id, card_number: card_number, card_expiration_date: card_expiration_date, details: details, cvv: cvv
                               })
        end

        def installments(token, details)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(INSTALLMENTS_ENDPOINT, token: token), @commerce_code, @api_key
          )
          details.map { 
            |detail| 
            request_service.post({commerce_code: detail['commerce_code'], buy_order: detail['buy_order'], installments_number: detail['installments_number']})
          }
        end
    
        def commit(token, details)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(COMMIT_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put({details: details})
        end

        def status(token)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(STATUS_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.get
        end
    
        def refund(token, buy_order, commerce_code_child, amount)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(REFUND_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.post(buy_order: buy_order, commerce_code: commerce_code_child, amount: amount)
        end     
        
        def capture(token, commerce_code, buy_order, authorization_code, amount)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(CAPTURE_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put(buy_order: buy_order, commerce_code: commerce_code, authorization_code: authorization_code, capture_amount: amount)
        end  
      end  
    end
  end
end