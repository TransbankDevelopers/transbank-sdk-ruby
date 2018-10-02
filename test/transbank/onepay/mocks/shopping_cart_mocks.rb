require 'transbank/sdk/onepay/models/item'
require 'transbank/sdk/onepay/models/shopping_cart'

module Transbank
  module Onepay
    module Mocks
      class ShoppingCartMocks

        @mocks = []
        cart = ShoppingCart.new
        item1 = Item.new('Zapatos', 1, 15000, nil, -1)
        item2 = Item.new('Pantalon', 1, 12500, nil, -1)

        cart << item1
        cart << item2

        @mocks.push cart


        class << self
          attr_accessor :mocks

          def [](index)
            self.mocks[index]
          end

          def << (shopping_cart_mock)
            self.mocks << shopping_cart_mock
          end
        end
      end
    end
  end
end
