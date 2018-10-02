
module Transbank
  module Onepay
    module Response
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
