# frozen_string_literals: true

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

      @configuration = nil
      @wsdl = nil

      def initialize(configuration)
        @configuration = configuration
        @wsdl = WSDL_URL[@configuration.environment.to_sym]
      end

      def init_transaction(amount, buy_order, session_id, url_return, url_final)
        
      end
    end
  end
end
