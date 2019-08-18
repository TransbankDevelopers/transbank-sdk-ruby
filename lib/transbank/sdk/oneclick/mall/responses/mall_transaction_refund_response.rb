module Transbank
  module Webpay
    module Oneclick
      class MallTransactionRefundResponse
        FIELDS =  [:type, :authorizationCode,  :authorizationDate,
                   :nullifiedAmount, :balance, :responseCode]
        
        attr_accessor *FIELDS

        def initialize(json)
          FIELDS.each {|field| send("#{field}=", json["#{field}"]) }
        end
      end
    end
  end
end
