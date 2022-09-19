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
        INCREASE_AMOUNT_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/amount').freeze
        INCREASE_AUTHORIZATION_DATE_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/authorization_date').freeze
        REVERSE_PRE_AUTHORIZED_AMOUNT_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/reverse/amount').freeze
        DEFERRED_CAPTURE_HISTORY_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/details').freeze
    
        def initialize(commerce_code = ::Transbank::Common::IntegrationCommerceCodes::TRANSACCION_COMPLETA_MALL, api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, environment = DEFAULT_ENVIRONMENT)
          super(commerce_code, api_key, environment)
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
        
        def increase_amount(token, child_commerce_code, child_buy_order, authorization_code, amount)
          
          Transbank::Common::Validation.has_text_with_max_length(child_commerce_code, Transbank::Common::ApiConstants::COMMERCE_CODE_LENGTH, "child_commerce_code")
          Transbank::Common::Validation.has_text_with_max_length(token, Transbank::Common::ApiConstants::TOKEN_LENGTH, "token")
          Transbank::Common::Validation.has_text_with_max_length(child_buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "child_buy_order")
          Transbank::Common::Validation.has_text_with_max_length(authorization_code, Transbank::Common::ApiConstants::AUTHORIZATION_CODE_LENGTH, "authorization_code")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(INCREASE_AMOUNT_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put(commerce_code: child_commerce_code, buy_order: child_buy_order, authorization_code: authorization_code, amount: amount)
        end

        def increase_authorization_date(token, child_commerce_code, child_buy_order, authorization_code)
          
          Transbank::Common::Validation.has_text_with_max_length(child_commerce_code, Transbank::Common::ApiConstants::COMMERCE_CODE_LENGTH, "child_commerce_code")
          Transbank::Common::Validation.has_text_with_max_length(token, Transbank::Common::ApiConstants::TOKEN_LENGTH, "token")
          Transbank::Common::Validation.has_text_with_max_length(child_buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "child_buy_order")
          Transbank::Common::Validation.has_text_with_max_length(authorization_code, Transbank::Common::ApiConstants::AUTHORIZATION_CODE_LENGTH, "authorization_code")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(INCREASE_AUTHORIZATION_DATE_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put(commerce_code: child_commerce_code, buy_order: child_buy_order, authorization_code: authorization_code)
        end

        def reverse_pre_authorized_amount(token, child_commerce_code, child_buy_order, authorization_code, amount)
          
          Transbank::Common::Validation.has_text_with_max_length(child_commerce_code, Transbank::Common::ApiConstants::COMMERCE_CODE_LENGTH, "child_commerce_code")
          Transbank::Common::Validation.has_text_with_max_length(token, Transbank::Common::ApiConstants::TOKEN_LENGTH, "token")
          Transbank::Common::Validation.has_text_with_max_length(child_buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "child_buy_order")
          Transbank::Common::Validation.has_text_with_max_length(authorization_code, Transbank::Common::ApiConstants::AUTHORIZATION_CODE_LENGTH, "authorization_code")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(REVERSE_PRE_AUTHORIZED_AMOUNT_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put(commerce_code: child_commerce_code, buy_order: child_buy_order, authorization_code: authorization_code, amount: amount)
        end

        def deferred_capture_history(token, child_commerce_code, child_buy_order)
          
          Transbank::Common::Validation.has_text_with_max_length(child_commerce_code, Transbank::Common::ApiConstants::COMMERCE_CODE_LENGTH, "child_commerce_code")
          Transbank::Common::Validation.has_text_with_max_length(token, Transbank::Common::ApiConstants::TOKEN_LENGTH, "token")
          Transbank::Common::Validation.has_text_with_max_length(child_buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "child_buy_order")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(DEFERRED_CAPTURE_HISTORY_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.post(commerce_code: child_commerce_code, buy_order: child_buy_order)
        end
      end  
    end
  end
end