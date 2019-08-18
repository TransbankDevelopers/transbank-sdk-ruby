module Transbank
  module Webpay
    module Oneclick
      class MallInscriptionStartResponse
        attr_accessor :token, :url_webpay

        def initialize(json)
          @token = json['token']
          @url_webpay = json['url_webpay']
        end
      end
    end
  end
end
