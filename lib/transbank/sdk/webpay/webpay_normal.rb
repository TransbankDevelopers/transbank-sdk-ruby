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
        ws_client.call(
          :init_transaction,
          xml: XmlSigner.perform(request_xml.body, @configuration)
        )
      end

      def transaction_result(token)
        ws_client = ::Savon.client(wsdl: wsdl)
        request_xml = ws_client.build_request(
          :get_transaction_result,
          message: WebServiceInput.transaction_result(token)
        )
        ws_client.call(
          :get_transaction_result,
          xml: XmlSigner.perform(request_xml.body, @configuration)
        )
      end

      private

      def wsdl
        WSDL_URL[@configuration.environment.to_sym]
      end
    end
  end
end