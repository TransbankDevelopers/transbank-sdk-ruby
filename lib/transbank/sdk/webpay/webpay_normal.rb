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
        ws_client = new_savon_client
        input = WebServiceInput.init_transaction(
          amount: amount, buy_order: buy_order, session_id: session_id,
          return_url: return_url, final_url: final_url,
          commerce_code: @configuration.commerce_code
        )
        request_xml = ws_client.build_request(:init_transaction, message: input)

        response = call_webservice(ws_client, :init_transaction, request_xml)

        WebServiceOutput::InitTransaction.new(response)
      end

      def transaction_result(token)
        ws_client = new_savon_client
        request_xml = ws_client.build_request(
          :get_transaction_result,
          message: WebServiceInput.transaction_result(token)
        )
        response = call_webservice(ws_client, :get_transaction_result, request_xml)

        ack_xml = ws_client.build_request(
          :acknowledge_transaction,
          message: WebServiceInput.acknowledge_transaction(token)
        )
        call_webservice(ws_client, :acknowledge_transaction, ack_xml)

        WebServiceOutput::TransactionResult.new(
          response.merge(
            card_detail: WebServiceOutput::CardDetail.new(
              response[:card_detail]
            ),
            detail_output: WebServiceOutput::DetailOutput.new(
              response[:detail_output]
            )
          )
        )
      end

      private

      def new_savon_client
        ::Savon.client(wsdl: wsdl, ssl_verify_mode: :peer)
      end

      def wsdl
        WSDL_URL[@configuration.environment.to_sym]
      end

      def call_webservice(client, action, xml)
        client.call(action, xml: XmlSigner.perform(xml.body, @configuration))
              .body.to_h["#{action}_response".to_sym][:return]
      end
    end
  end
end
