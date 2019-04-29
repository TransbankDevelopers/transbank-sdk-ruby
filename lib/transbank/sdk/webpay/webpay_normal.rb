# frozen_string_literals: true
require 'savon'
module Transbank
  module Webpay
    # Normal transaction class
    class WebpayNormal
      WSDL_URL = {
        INTEGRACION: 'https://webpay3gint.transbank.cl/WSWebpayTransaction/cxf/WSWebpayService?wsdl',
        PRODUCCION: 'https://webpay3g.transbank.cl/WSWebpayTransaction/cxf/WSWebpayService?wsdl'
      }.freeze

      RESULT_CODES = {
        '0': 'Transacción aprobada',
        '-1': 'Rechazo de transacción',
        '-2': 'Transacción debe reintentarse',
        '-3': 'Error en transacción',
        '-4': 'Rechazo de transacción',
        '-5': 'Rechazo por error de tasa',
        '-6': 'Excede cupo máximo mensual',
        '-7': 'Excede límite diario por transacción',
        '-8': 'Rubro no autorizado'
      }.freeze

      def initialize(configuration)
        @configuration = configuration
      end

      def init_transaction(amount, buy_order, session_id, return_url, final_url)
        ws_client = ::Savon.client(wsdl: wsdl)
        input = WebServiceInput.init_transaction(
          amount: amount, buy_order: buy_order, session_id: session_id,
          return_url: return_url, final_url: final_url,
          commerce_code: @configuration.commerce_code
        )
        request_xml = ws_client.build_request(:init_transaction, message: input)

        response = ws_client.call(
          :init_transaction,
          xml: XmlSigner.perform(request_xml.body, @configuration)
        ).body.to_h[:init_transaction_response][:return]

        WebServiceOutput::InitTransaction.new(response)
      end

      def transaction_result(token)
        ws_client = ::Savon.client(wsdl: wsdl)
        request_xml = ws_client.build_request(
          :get_transaction_result,
          message: WebServiceInput.transaction_result(token)
        )
        response = ws_client.call(
          :get_transaction_result,
          xml: XmlSigner.perform(request_xml.body, @configuration)
        ).body.to_h[:get_transaction_result_response][:return]

        ack_xml = ws_client.build_request(
          :acknowledge_transaction,
          message: WebServiceInput.acknowledge_transaction(token)
        )

        ws_client.call(
          :acknowledge_transaction,
          xml: XmlSigner.perform(ack_xml.body, @configuration)
        )

        WebServiceOutput::TransactionResult.new(
          accounting_date: response[:accounting_date],
          buy_order: response[:buy_order],
          card_detail: WebServiceOutput::CardDetail.new(
            card_number: response[:card_detail][:card_number]
          ),
          detail_output: WebServiceOutput::DetailOutput.new(
            shares_number: response[:detail_output][:shares_number],
            amount: response[:detail_output][:amount],
            commerce_code: response[:detail_output][:commerce_code],
            buy_order: response[:detail_output][:buy_order],
            authorization_code: response[:detail_output][:authorization_code],
            payment_type_code: response[:detail_output][:payment_type_code],
            response_code: response[:detail_output][:response_code]
          ),
          session_id: response[:session_id],
          transaction_date: response[:transaction_date],
          url_redirection: response[:url_redirection],
          vci: response[:vci]
        )
      end

      private

      def wsdl
        WSDL_URL[@configuration.environment.to_sym]
      end
    end
  end
end
