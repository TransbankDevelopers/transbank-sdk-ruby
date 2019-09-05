module Transbank
  module Patpass
    module PatpassComercio
      class InscriptionStatusResponse
        attr_accessor :status, :url_voucher
        def initialize(json)
          self.status = json['status']
          self.url_voucher = json['urlVoucher']
        end
      end
    end
  end
end
