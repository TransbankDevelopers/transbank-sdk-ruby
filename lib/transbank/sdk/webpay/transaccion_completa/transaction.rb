module Transbank
  module Webpay
    module TransaccionCompleta
      class Transaction < ::Transbank::Common::BaseTransaction
        DEFAULT_ENVIRONMENT = :integration
        RESOURCES_URL = ::Transbank::Common::ApiConstants::WEBPAY_ENDPOINT
        CREATE_ENDPOINT = (RESOURCES_URL + '/transactions/').freeze
        INSTALLMENTS_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/installments').freeze
        COMMIT_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}').freeze
        STATUS_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}').freeze
        REFUND_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/refunds').freeze
        CAPTURE_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/capture').freeze
    
        def initialize(commerce_code = ::Transbank::Common::IntegrationCommerceCodes::TRANSACCION_COMPLETA, api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, environment = DEFAULT_ENVIRONMENT)
          super
        end
    
        def create(buy_order, session_id, amount, cvv, card_number, card_expiration_date)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, CREATE_ENDPOINT, @commerce_code, @api_key
          )
          request_service.post({
                                 buy_order: buy_order, session_id: session_id, amount: amount, cvv: cvv, card_number: card_number, card_expiration_date: card_expiration_date
                               })
        end

        def installments(token, installments_number)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(INSTALLMENTS_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.post({installments_number: installments_number})
        end
    
        def commit(token, id_query_installments, deferred_period_index, grace_period)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(COMMIT_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put({id_query_installments: id_query_installments, deferred_period_index: deferred_period_index, grace_period: grace_period})
        end

        def status(token)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(STATUS_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.get
        end
    
        def refund(token, amount)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(REFUND_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.post(amount: amount)
        end     
        
        def capture(token, buy_order, authorization_code, amount)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(CAPTURE_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put(buy_order: buy_order, authorization_code: authorization_code, capture_amount: amount)
        end 
      end
    end
  end
end