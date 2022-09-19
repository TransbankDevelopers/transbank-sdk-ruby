module Transbank
  module Webpay
    module WebpayPlus
      class Transaction < ::Transbank::Common::BaseTransaction
        DEFAULT_ENVIRONMENT = :integration
        RESOURCES_URL = ::Transbank::Common::ApiConstants::WEBPAY_ENDPOINT
        CREATE_ENDPOINT = (RESOURCES_URL + '/transactions/').freeze
        COMMIT_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}').freeze
        STATUS_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}').freeze
        REFUND_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/refunds').freeze
        CAPTURE_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/capture').freeze
        INCREASE_AMOUNT_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/amount').freeze
        INCREASE_AUTHORIZATION_DATE_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/authorization_date').freeze
        REVERSE_PRE_AUTHORIZED_AMOUNT_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/reverse/amount').freeze
        DEFERRED_CAPTURE_HISTORY_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/details').freeze

    
        def initialize(commerce_code = ::Transbank::Common::IntegrationCommerceCodes::WEBPAY_PLUS, api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, environment = DEFAULT_ENVIRONMENT)
          super(commerce_code, api_key, environment)
        end
    
        def create(buy_order, session_id, amount, return_url)

          Transbank::Common::Validation.has_text_with_max_length(buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "buy_order")
          Transbank::Common::Validation.has_text_with_max_length(session_id, Transbank::Common::ApiConstants::SESSION_ID_LENGTH, "session_id")
          Transbank::Common::Validation.has_text_with_max_length(return_url, Transbank::Common::ApiConstants::RETURN_URL_LENGTH, "return_url")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, CREATE_ENDPOINT, @commerce_code, @api_key
          )
          request_service.post({
                                 buy_order: buy_order, session_id: session_id, amount: amount, return_url: return_url
                               })
        end
    
        def commit(token)

          Transbank::Common::Validation.has_text_with_max_length(token, Transbank::Common::ApiConstants::TOKEN_LENGTH, "token")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(COMMIT_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put({})
        end

        def status(token)

          Transbank::Common::Validation.has_text_with_max_length(token, Transbank::Common::ApiConstants::TOKEN_LENGTH, "token")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(STATUS_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.get
        end
    
        def refund(token, amount)

          Transbank::Common::Validation.has_text_with_max_length(token, Transbank::Common::ApiConstants::TOKEN_LENGTH, "token")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(REFUND_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.post(amount: amount)
        end     
        
        def capture(token, buy_order, authorization_code, amount)
          
          Transbank::Common::Validation.has_text_with_max_length(token, Transbank::Common::ApiConstants::TOKEN_LENGTH, "token")
          Transbank::Common::Validation.has_text_with_max_length(buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "buy_order")
          Transbank::Common::Validation.has_text_with_max_length(authorization_code, Transbank::Common::ApiConstants::AUTHORIZATION_CODE_LENGTH, "authorization_code")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(CAPTURE_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put(buy_order: buy_order, authorization_code: authorization_code, capture_amount: amount)
        end 

        def increase_amount(token, buy_order, authorization_code, amount)
          
          Transbank::Common::Validation.has_text_with_max_length(token, Transbank::Common::ApiConstants::TOKEN_LENGTH, "token")
          Transbank::Common::Validation.has_text_with_max_length(buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "buy_order")
          Transbank::Common::Validation.has_text_with_max_length(authorization_code, Transbank::Common::ApiConstants::AUTHORIZATION_CODE_LENGTH, "authorization_code")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(INCREASE_AMOUNT_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put(commerce_code: @commerce_code, buy_order: buy_order, authorization_code: authorization_code, amount: amount)
        end

        def increase_authorization_date(token, buy_order, authorization_code)
          
          Transbank::Common::Validation.has_text_with_max_length(token, Transbank::Common::ApiConstants::TOKEN_LENGTH, "token")
          Transbank::Common::Validation.has_text_with_max_length(buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "buy_order")
          Transbank::Common::Validation.has_text_with_max_length(authorization_code, Transbank::Common::ApiConstants::AUTHORIZATION_CODE_LENGTH, "authorization_code")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(INCREASE_AUTHORIZATION_DATE_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put(commerce_code: @commerce_code, buy_order: buy_order, authorization_code: authorization_code)
        end

        def reverse_pre_authorized_amount(token, buy_order, authorization_code, amount)
          
          Transbank::Common::Validation.has_text_with_max_length(token, Transbank::Common::ApiConstants::TOKEN_LENGTH, "token")
          Transbank::Common::Validation.has_text_with_max_length(buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "buy_order")
          Transbank::Common::Validation.has_text_with_max_length(authorization_code, Transbank::Common::ApiConstants::AUTHORIZATION_CODE_LENGTH, "authorization_code")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(REVERSE_PRE_AUTHORIZED_AMOUNT_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.put(commerce_code: @commerce_code, buy_order: buy_order, authorization_code: authorization_code, amount: amount)
        end

        def deferred_capture_history(token)
          
          Transbank::Common::Validation.has_text_with_max_length(token, Transbank::Common::ApiConstants::TOKEN_LENGTH, "token")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(DEFERRED_CAPTURE_HISTORY_ENDPOINT, token: token), @commerce_code, @api_key
          )
          request_service.get
        end

      end
    end
  end
end