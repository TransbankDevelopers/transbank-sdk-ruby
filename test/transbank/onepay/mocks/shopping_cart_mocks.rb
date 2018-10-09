require 'transbank/sdk/onepay/models/item'
require 'transbank/sdk/onepay/models/shopping_cart'

module Transbank
  module Onepay
    module Mocks
      class ShoppingCartMocks

        @mocks = []
        cart = ShoppingCart.new
        item1 = Item.new(description: 'Zapatos', quantity: 1, amount: 15000, additional_data: nil, expire:  -1)
        item2 = Item.new(description: 'Pantalon', quantity: 1, amount: 12500, additional_data: nil, expire: -1)

        cart << item1
        cart << item2

        @mocks.push cart


        class << self
          attr_accessor :mocks

          def [](index)
            @mocks[index]
          end

          def << (shopping_cart_mock)
            @mocks << shopping_cart_mock
          end
        end
      end
    end
  end
end
