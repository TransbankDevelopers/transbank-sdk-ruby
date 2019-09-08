module Transbank
  module Patpass
    module PatpassComercio
      class InscriptionStatusResponse
        attr_accessor :authorized, :voucher_url
        def initialize(json)
          self.authorized = json['authorized']
          self.voucher_url = json['voucherUrl']
        end
      end
    end
  end
end
