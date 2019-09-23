module Transbank
  module Patpass
    module PatpassComercio
      class InscriptionStartResponse
        attr_accessor :token, :url
        def initialize(json)
          self.token = json['token']
          self.url = json['url']
        end
      end
    end
  end
end
