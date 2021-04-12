module Transbank
  module TransaccionCompleta
    class MallTransactionCaptureResponse
      FIELDS = %i[token authorization_code authorization_date captured_amount response_code].freeze
      attr_accessor(*FIELDS)

      def initialize(json)
        FIELDS.each { |field| send("#{field}=", json[field.to_s]) }
      end
    end
  end
end
