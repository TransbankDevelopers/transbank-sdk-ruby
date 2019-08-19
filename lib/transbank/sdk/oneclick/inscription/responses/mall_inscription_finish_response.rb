module Transbank
  module Webpay
    module Oneclick
      class MallInscriptionFinishResponse
        FIELDS = [:response_code, :tbk_user, :authorization_code,
                  :credit_card_type, :last_four_card_digits]
        attr_accessor *FIELDS
        def initialize(json)
          FIELDS.each {|field| send("#{field}=", json["#{field}"]) }
        end
      end
    end
  end
end

