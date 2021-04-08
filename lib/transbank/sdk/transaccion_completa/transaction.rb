module Transbank
  module TransaccionCompleta
    class Transaction
      extend Utils::NetHelper

      CREATE_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions'
      TRANSACTION_INSTALLMENTS_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions/:token/installments'
      COMMIT_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions/:token'
      TRANSACTION_STATUS_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions/:token'
      REFUND_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions/:token/refunds'
      CAPTURE_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions/:token/capture'

      class << self
        def create(buy_order:, session_id:, amount:, card_number:, cvv:,
                   card_expiration_date:, options: nil)
          api_key = options&.api_key || default_integration_params[:api_key]
          commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
          integration_type = options&.integration_type || default_integration_params[:integration_type]
          base_url = integration_type.nil? ? TransaccionCompleta::Base.integration_type[:TEST] : TransaccionCompleta::Base.integration_type_url(integration_type)

          body = {
            buy_order: buy_order, session_id: session_id,
            amount: amount, card_number: card_number, cvv: cvv,
            card_expiration_date: card_expiration_date
          }

          url = base_url + CREATE_TRANSACTION_ENDPOINT
          headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
          resp = http_post(uri_string: url, body: body, headers: headers, camel_case_keys: false)
          body = JSON.parse(resp.body)
          return ::Transbank::TransaccionCompleta::TransactionCreateResponse.new(body) if resp.is_a? Net::HTTPSuccess

          raise Errors::TransactionCreateError.new(body['error_message'], resp.code)
        end

        def installments(token:, installments_number:, options: nil)
          api_key = options&.api_key || default_integration_params[:api_key]
          commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
          integration_type = options&.integration_type || default_integration_params[:integration_type]
          base_url = integration_type.nil? ? TransaccionCompleta::Base.integration_type[:TEST] : TransaccionCompleta::Base.integration_type_url(integration_type)

          url = base_url + TRANSACTION_INSTALLMENTS_ENDPOINT.gsub(':token', token)
          headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)

          body = { installments_number: installments_number }

          resp = http_post(uri_string: url, body: body, headers: headers, camel_case_keys: false)
          body = JSON.parse(resp.body)
          if resp.is_a? Net::HTTPSuccess
            return ::Transbank::TransaccionCompleta::TransactionInstallmentsResponse.new(body)
          end

          raise Errors::TransactionInstallmentsError.new(body['error_message'], resp.code)
        end

        def commit(token:, id_query_installments:, deferred_period_index:,
                   grace_period:, options: nil)
          api_key = options&.api_key || default_integration_params[:api_key]
          commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
          integration_type = options&.integration_type || default_integration_params[:integration_type]
          base_url = integration_type.nil? ? TransaccionCompleta::Base.integration_type[:TEST] : TransaccionCompleta::Base.integration_type_url(integration_type)

          url = base_url + COMMIT_TRANSACTION_ENDPOINT.gsub(':token', token)
          headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
          body = {
            id_query_installments: id_query_installments,
            deferred_period_index: deferred_period_index,
            grace_period: grace_period
          }

          resp = http_put(uri_string: url, body: body, headers: headers)
          body = JSON.parse(resp.body)
          return ::Transbank::TransaccionCompleta::TransactionCommitResponse.new(body) if resp.is_a? Net::HTTPSuccess

          raise Errors::TransactionCommitError.new(body['error_message'], resp.code)
        end

        def status(token:, options: nil)
          api_key = options&.api_key || default_integration_params[:api_key]
          commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
          integration_type = options&.integration_type || default_integration_params[:integration_type]
          base_url = integration_type.nil? ? TransaccionCompleta::Base.integration_type[:TEST] : TransaccionCompleta::Base.integration_type_url(integration_type)

          url = base_url + TRANSACTION_STATUS_ENDPOINT.gsub(':token', token)
          headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
          resp = http_get(uri_string: url, headers: headers)
          body = JSON.parse(resp.body)
          return ::Transbank::TransaccionCompleta::TransactionStatusResponse.new(body) if resp.is_a? Net::HTTPSuccess

          raise Errors::TransactionStatusError.new(body['error_message'], resp.code)
        end

        def refund(token:, amount:, options: nil)
          api_key = options&.api_key || default_integration_params[:api_key]
          commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
          integration_type = options&.integration_type || default_integration_params[:integration_type]
          base_url = integration_type.nil? ? TransaccionCompleta::Base.integration_type[:TEST] : TransaccionCompleta::Base.integration_type_url(integration_type)

          body = {
            amount: amount
          }

          url = base_url + REFUND_TRANSACTION_ENDPOINT.gsub(':token', token)
          headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
          resp = http_post(uri_string: url, body: body, headers: headers, camel_case_keys: false)
          body = JSON.parse(resp.body)
          return ::Transbank::TransaccionCompleta::TransactionRefundResponse.new(body) if resp.is_a? Net::HTTPSuccess

          raise Errors::TransactionRefundError.new(body['error_message'], resp.code)
        end

        def capture(token:, buy_order:, authorization_code:, capture_amount:, options: nil)
          api_key = options&.api_key || default_integration_params[:api_key]
          commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
          integration_type = options&.integration_type || default_integration_params[:integration_type]
          base_url = integration_type.nil? ? TransaccionCompleta::Base.integration_type[:TEST] : TransaccionCompleta::Base.integration_type_url(integration_type)

          body = {
            buy_order: buy_order,
            authorization_code: authorization_code,
            capture_amount: capture_amount
          }

          url = base_url + CAPTURE_TRANSACTION_ENDPOINT.gsub(':token', token)
          headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
          resp = http_put(uri_string: url, body: body, headers: headers)
          body = JSON.parse(resp.body)
          return ::Transbank::TransaccionCompleta::TransactionCaptureResponse.new(body) if resp.is_a? Net::HTTPSuccess

          raise Errors::TransactionCaptureError.new(body['error_message'], resp.code)
        end

        def default_integration_params
          {
            api_key: TransaccionCompleta::Base.api_key,
            commerce_code: TransaccionCompleta::Base.commerce_code,
            integration_type: TransaccionCompleta::Base.integration_type,
            base_url: TransaccionCompleta::Base.current_integration_type_url
          }
        end
      end
    end
  end
end
