module Transbank
  module TransaccionCompleta
    class MallTransaction
      extend Utils::NetHelper

      CREATE_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions'
      TRANSACTION_INSTALLMENTS_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions/:token/installments'
      COMMIT_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions/:token'
      TRANSACTION_STATUS_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions/:token'
      REFUND_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions/:token/refunds'
      CAPTURE_TRANSACTION_ENDPOINT = 'rswebpaytransaction/api/webpay/v1.0/transactions/:token/capture'

      class << self
        def create(
          buy_order:, session_id:, card_number:, card_expiration_date:, details:, cvv: nil, options: nil
        )
          api_key = options&.api_key || default_integration_params[:api_key]
          commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
          integration_type = options&.integration_type || default_integration_params[:integration_type]
          base_url = integration_type.nil? ? TransaccionCompleta::Base.integration_type[:TEST] : TransaccionCompleta::Base.integration_type_url(integration_type)

          detail = create_details(details)
          body = {
            buy_order: buy_order, session_id: session_id,
            card_number: card_number, card_expiration_date: card_expiration_date,
            details: detail
          }
          body[:cvv] = cvv unless cvv.nil?

          url = base_url + CREATE_TRANSACTION_ENDPOINT
          headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
          resp = http_post(uri_string: url, body: body, headers: headers, camel_case_keys: false)
          body = JSON.parse(resp.body)
          return ::Transbank::TransaccionCompleta::TransactionCreateResponse.new(body) if resp.is_a? Net::HTTPSuccess

          raise Errors::TransactionCreateError.new(body['error_message'], resp.code)
        end

        def installments(token:, details:, options: nil)
          api_key = options&.api_key || default_integration_params[:api_key]
          base_commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
          integration_type = options&.integration_type || default_integration_params[:integration_type]
          base_url = integration_type.nil? ? TransaccionCompleta::Base.integration_type[:TEST] : TransaccionCompleta::Base.integration_type_url(integration_type)

          url = base_url + TRANSACTION_INSTALLMENTS_ENDPOINT.gsub(':token', token)
          headers = webpay_headers(commerce_code: base_commerce_code, api_key: api_key)

          detail = installments_details(details)

          resp = detail.map do |det|
            body = {
              commerce_code: det[:commerce_code],
              buy_order: det[:buy_order],
              installments_number: det[:installments_number]
            }
            http_post(uri_string: url, body: body, headers: headers, camel_case_keys: false)
          end

          if resp.all? { |res| res.is_a? Net::HTTPSuccess }
            return resp.map do |res|
              body = JSON.parse(res.body)
              ::Transbank::TransaccionCompleta::TransactionInstallmentsResponse.new(body)
            end
          end

          raise Errors::TransactionInstallmentsError.new(resp, resp.code)
        end

        def commit(token:, details:, options: nil)
          api_key = options&.api_key || default_integration_params[:api_key]
          commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
          integration_type = options&.integration_type || default_integration_params[:integration_type]
          base_url = integration_type.nil? ? TransaccionCompleta::Base.integration_type[:TEST] : TransaccionCompleta::Base.integration_type_url(integration_type)

          url = base_url + COMMIT_TRANSACTION_ENDPOINT.gsub(':token', token)
          headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)

          detail = commit_details(details)
          body = { details: detail }

          resp = http_put(uri_string: url, body: body, headers: headers)
          body = JSON.parse(resp.body)
          if resp.is_a? Net::HTTPSuccess
            return ::Transbank::TransaccionCompleta::MallTransactionCommitResponse.new(body)
          end

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
          if resp.is_a? Net::HTTPSuccess
            return ::Transbank::TransaccionCompleta::MallTransactionStatusResponse.new(body)
          end

          raise Errors::TransactionStatusError.new(body['error_message'], resp.code)
        end

        def refund(token:, child_buy_order:, child_commerce_code:, amount:, options: nil)
          api_key = options&.api_key || default_integration_params[:api_key]
          commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
          integration_type = options&.integration_type || default_integration_params[:integration_type]
          base_url = integration_type.nil? ? TransaccionCompleta::Base.integration_type[:TEST] : TransaccionCompleta::Base.integration_type_url(integration_type)

          body = {
            buy_order: child_buy_order,
            commerce_code: child_commerce_code,
            amount: amount
          }

          url = base_url + REFUND_TRANSACTION_ENDPOINT.gsub(':token', token)
          headers = webpay_headers(commerce_code: commerce_code, api_key: api_key)
          resp = http_post(uri_string: url, body: body, headers: headers, camel_case_keys: false)
          body = JSON.parse(resp.body)
          return ::Transbank::TransaccionCompleta::TransactionRefundResponse.new(body) if resp.is_a? Net::HTTPSuccess

          raise Errors::TransactionRefundError.new(body['error_message'], resp.code)
        end

        def capture(token:, commerce_code:, buy_order:, authorization_code:, capture_amount:, options: nil)
          api_key = options&.api_key || default_integration_params[:api_key]
          parent_commerce_code = options&.commerce_code || default_integration_params[:commerce_code]
          integration_type = options&.integration_type || default_integration_params[:integration_type]
          base_url = integration_type.nil? ? TransaccionCompleta::Base.integration_type[:TEST] : TransaccionCompleta::Base.integration_type_url(integration_type)

          body = {
            commerce_code: commerce_code,
            buy_order: buy_order,
            authorization_code: authorization_code,
            capture_amount: capture_amount
          }

          url = base_url + CAPTURE_TRANSACTION_ENDPOINT.gsub(':token', token)
          headers = webpay_headers(commerce_code: parent_commerce_code, api_key: api_key)
          resp = http_put(uri_string: url, body: body, headers: headers)
          body = JSON.parse(resp.body)
          if resp.is_a? Net::HTTPSuccess
            return ::Transbank::TransaccionCompleta::MallTransactionCaptureResponse.new(body)
          end

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

        private

        def create_details(details)
          details.map do |det|
            {
              amount: det.fetch('amount') { det.fetch(:amount) },
              commerce_code: det.fetch('commerce_code') { det.fetch(:commerce_code) },
              buy_order: det.fetch('buy_order') { det.fetch(:buy_order) }
            }
          end
        end

        def commit_details(details)
          details.map do |det|
            {
              commerce_code: det.fetch('commerce_code') { det.fetch(:commerce_code) },
              buy_order: det.fetch('buy_order') { det.fetch(:buy_order) },
              id_query_installments: det.fetch('id_query_installments') { det.fetch(:id_query_installments) },
              deferred_period_index: det.fetch('deferred_period_index') { det.fetch(:deferred_period_index) },
              grace_period: det.fetch('grace_period') { det.fetch(:grace_period) }
            }
          end
        end

        def installments_details(details)
          details.map do |det|
            {
              installments_number: det.fetch('installments_number') { det.fetch(:installments_number) },
              buy_order: det.fetch('buy_order') { det.fetch(:buy_order) },
              commerce_code: det.fetch('commerce_code') { det.fetch(:commerce_code) }
            }
          end
        end
      end
    end
  end
end
