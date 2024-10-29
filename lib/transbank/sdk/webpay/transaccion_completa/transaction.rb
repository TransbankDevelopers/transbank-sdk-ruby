module Transbank
  module Webpay
    module TransaccionCompleta
      class Transaction < ::Transbank::Common::BaseTransaction
        private_class_method :new
        RESOURCES_URL = ::Transbank::Common::ApiConstants::WEBPAY_ENDPOINT
        CREATE_ENDPOINT = (RESOURCES_URL + '/transactions/').freeze
        INSTALLMENTS_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/installments').freeze
        COMMIT_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}').freeze
        STATUS_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}').freeze
        REFUND_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/refunds').freeze
        CAPTURE_ENDPOINT = (RESOURCES_URL + '/transactions/%{token}/capture').freeze
    
        def initialize(options)
          super
        end

        def self.new(options)
          super(options)
        end

        def self.build_for_integration(commerce_code, api_key)
          options = Options.new(
            commerce_code,
            api_key,
            :integration
          )
          
          new(options)
        end

        def self.build_for_production(commerce_code, api_key)
          options = Options.new(
            commerce_code,
            api_key,
            :production
          )
          new(options)
        end
    
        def create(buy_order, session_id, amount, cvv, card_number, card_expiration_date)

          Transbank::Common::Validation.has_text_with_max_length(buy_order, Transbank::Common::ApiConstants::BUY_ORDER_LENGTH, "buy_order")
          Transbank::Common::Validation.has_text_with_max_length(session_id, Transbank::Common::ApiConstants::SESSION_ID_LENGTH, "session_id")
          Transbank::Common::Validation.has_text_with_max_length(card_number, Transbank::Common::ApiConstants::CARD_NUMBER_LENGTH, "card_number")
          Transbank::Common::Validation.has_text_with_max_length(card_expiration_date, Transbank::Common::ApiConstants::CARD_EXPIRATION_DATE_LENGTH, "card_expiration_date")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, CREATE_ENDPOINT, @commerce_code, @api_key, @timeout
          )
          request_service.post({
                                 buy_order: buy_order, session_id: session_id, amount: amount, cvv: cvv, card_number: card_number, card_expiration_date: card_expiration_date
                               })
        end

        def installments(token, installments_number)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(INSTALLMENTS_ENDPOINT, token: token), @commerce_code, @api_key, @timeout
          )
          request_service.post({installments_number: installments_number})
        end
    
        def commit(token, id_query_installments, deferred_period_index, grace_period)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(COMMIT_ENDPOINT, token: token), @commerce_code, @api_key, @timeout
          )
          request_service.put({id_query_installments: id_query_installments, deferred_period_index: deferred_period_index, grace_period: grace_period})
        end

        def status(token)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(STATUS_ENDPOINT, token: token), @commerce_code, @api_key, @timeout
          )
          request_service.get
        end
    
        def refund(token, amount)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(REFUND_ENDPOINT, token: token), @commerce_code, @api_key, @timeout
          )
          request_service.post(amount: amount)
        end     
        
        def capture(token, buy_order, authorization_code, amount)
          request_service = ::Transbank::Shared::RequestService.new(
            @environment, format(CAPTURE_ENDPOINT, token: token), @commerce_code, @api_key, @timeout
          )
          request_service.put(buy_order: buy_order, authorization_code: authorization_code, capture_amount: amount)
        end
      end
    end
  end
end