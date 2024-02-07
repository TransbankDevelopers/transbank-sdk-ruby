module Transbank
  module Webpay
    module Oneclick
      class MallTransaction < ::Transbank::Common::BaseTransaction
        DEFAULT_ENVIRONMENT = :integration
        RESOURCES_URL = ::Transbank::Common::ApiConstants::ONECLICK_ENDPOINT
        AUTHORIZE_ENDPOINT = (RESOURCES_URL + '/transactions').freeze
        STATUS_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}').freeze
        REFUND_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/refunds').freeze
        CAPTURE_ENDPOINT = (RESOURCES_URL + '/transactions/capture').freeze
    
        def initialize(commerce_code = ::Transbank::Common::IntegrationCommerceCodes::ONECLICK_MALL, api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, environment = DEFAULT_ENVIRONMENT)
          super(commerce_code, api_key, environment)
        end
    
        def authorize(username, tbk_user, parent_buy_order, details)

          Transbank::Common::Validation.has_text_with_max_length(username, Transbank::Common::ApiConstants::USER_NAME_LENGTH, "username")
          Transbank::Common::Validation.has_text_with_max_length(tbk_user, Transbank::Common::ApiConstants::TBK_USER_LENGTH, "tbk_user")
          Transbank::Common::Validation.has_text_with_max_length(parent_buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "parent_buy_order")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, AUTHORIZE_ENDPOINT, @commerce_code, @api_key
          )
          request_service.post({
            username: username, tbk_user: tbk_user, buy_order: parent_buy_order, details: details
                               })
        end

        def capture(child_commerce_code, child_buy_order, authorization_code, amount)
         
          Transbank::Common::Validation.has_text_with_max_length(child_commerce_code, Transbank::Common::ApiConstants::COMMERCE_CODE_LENGTH, "child_commerce_code")
          Transbank::Common::Validation.has_text_with_max_length(child_buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "child_buy_order")
          Transbank::Common::Validation.has_text_with_max_length(authorization_code, Transbank::Common::ApiConstants::AUTHORIZATION_CODE_LENGTH, "authorization_code")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, CAPTURE_ENDPOINT, @commerce_code, @api_key
          )
          request_service.put(commerce_code: child_commerce_code, buy_order: child_buy_order, authorization_code: authorization_code, capture_amount: amount)
        end 

        def status(buy_order)

          Transbank::Common::Validation.has_text_with_max_length(buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "buy_order")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(STATUS_ENDPOINT, token: buy_order), @commerce_code, @api_key
          )
          request_service.get
        end
    
        def refund(buy_order, child_commerce_code, child_buy_order, amount)

          Transbank::Common::Validation.has_text_with_max_length(buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "buy_order")
          Transbank::Common::Validation.has_text_with_max_length(child_commerce_code, Transbank::Common::ApiConstants::COMMERCE_CODE_LENGTH, "child_commerce_code")
          Transbank::Common::Validation.has_text_with_max_length(child_buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "child_buy_order")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(REFUND_ENDPOINT, token: buy_order), @commerce_code, @api_key
          )
          request_service.post(detail_buy_order: child_buy_order, commerce_code: child_commerce_code, amount: amount)
        end
      end  
    end
  end
end