module Transbank
  module Onepay
    # Represents a Shopping Cart, which contains [Item]s that the user wants to buy
    class ShoppingCart
      include Utils::JSONUtils
      # @return [Integer] The amount in CLP of the [Item]s included in the [ShoppingCart]
      attr_reader :total

      # @param items [Array, nil] an array of Hashes that can be converted to [Item]
      # if nil, an empty shopping cart is created
      def initialize(items = [])
        # The amount in CLP of the [Item]s included in the [ShoppingCart]
        @total = 0
        # An [Array<Item>] with the [ShoppingCart] contents
        @items = []
        return if items.nil? || items.empty?

        items.each do |it|
          it = transform_hash_keys it
          item = Item.new it
          self << item
        end
      end

      # @param item [Item] an instance of [Item]
      # @return [boolean] return true if item is successfully added
      def add(item)
        new_total = total + item.total
        if new_total < 0
          raise Errors::ShoppingCartError, "New total amount cannot be less than zero."
        end
        @items << item
        @total = new_total
        true
      end

      # Alias for #add
      def << item
        add item
      end

      # Remove an [Item] from self
      # @return [boolean] return true if the item is successfully removed
      def remove(item)
        new_total = total - item.total
        if new_total < 0
          raise Errors::ShoppingCartError, "New total amount cannot be less than zero."
        end
        first_instance_of_item = @items.index(item)
        if first_instance_of_item.nil?
          raise Errors::ShoppingCartError, 'Item not found'
        end
        @items.delete_at first_instance_of_item
        @total = new_total
        true
      end

      # Clear the cart, setting @total to 0 and @items to []
      # @return [boolean] true
      def remove_all
        @total = 0
        @items = []
        true
      end

      # @return [Array<Item>] An [Array<Item>] with the [ShoppingCart] contents
      def items
        # Return a copy of the items so you cannot modify the items that are
        # in the cart from the outside, since that could cause inconsistencies
        @items.map &:clone
      end

      # Sum the quantity of items in the cart
      def items_quantity
        # Array#sum is Ruby 2.4+
        @items.reduce(0) { |total, item| total + item.quantity }
      end
    end
  end
end
