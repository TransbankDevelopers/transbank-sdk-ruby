require 'transbank/sdk/onepay/utils/jsonify'

module Transbank
  module Onepay
    # TODO: YARD this class
    class ShoppingCart
      include Utils::JSONifier
      # Represents a Shopping Cart, which contains [Item]s that the user wants to buy


      # @return [Integer] The amount in CLP of the [Item]s included in the [ShoppingCart]
      attr_reader :total

      def initialize
        # The amount in CLP of the [Item]s included in the [ShoppingCart]
        @total = 0
        # An [Array<Item>] with the [ShoppingCart] contents
        @items = []
      end

      # @param item [Item] an instance of [Item]
      # @return [boolean] return true if item is successfully added
      def add(item)
        new_total = calculate_total(item)
        @items << item
        @total = new_total
        true
      end

      # Call #add(item) on self, see docs for #add
      def << item
        add item
      end

      def remove(item)
        new_total = calculate_total(item)
        first_instance_of_item = @items.index(item)
        @items.delete_at first_instance_of_item
        @total = new_total
        true
      end

      def remove_all
        @total = 0
        @items = []
      end

      # @return [Array<Item>] An [Array<Item>] with the [ShoppingCart] contents
      def items
        @items.map &:clone
      end

      # TODO: YARD
      def items_quantity
        @items.reduce(0) { |total, item| total + item.quantity }
      end

      private
      def calculate_total(item)
        new_total = @total + item.amount * item.quantity
        if new_total < 0
          raise ShoppingCartError "New total amount cannot be less than zero."
        end
        new_total
      end
    end
  end
end
