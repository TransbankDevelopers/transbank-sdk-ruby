module Transbank
  module Onepay
    # Shared methods and attributes between all types of Responses
    module Response
      include Utils::SignatureUtils
      attr_accessor :response_code
      attr_accessor :description

      def response_ok?
        response_code.downcase == 'ok'
      end

      def full_description
        "#{ response_code } : #{ description }"
      end
    end
  end
end
