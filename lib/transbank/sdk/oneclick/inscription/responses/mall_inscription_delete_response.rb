module Transbank
  module Webpay
    module Oneclick
      class MallInscriptionDeleteResponse
        attr_accessor :status, :code
        def initialize(code)
          @code = code
          if code == 200
            @status = 'OK'
          elsif code == 404
            @status = 'Not found'
          end
        end
      end
    end
  end
end
