module Transbank
  module Onepay
    # Represents a Shopping Cart, which contains [Item]s that the user wants to buy
    class ShoppingCart
      include Utils::JSONUtils

      # @return [Array<Item>] An [Array<Item>] with the [ShoppingCart] contents
      attr_reader :items

      # @param items [Array, nil] an array of Hashes that can be converted to [Item]
      # if nil, an empty shopping cart is created
      def initialize(items = [])
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
          raise Errors::ShoppingCartError, "Total amount cannot be less than zero."
        end
        @items << item
      end

      # Alias for #add
      def << item
        add item
      end

      # Remove an [Item] from self
      # @raise [ShoppingCartError] if item is not found
      def remove(item)
        if @items.delete(item).nil?
          raise Errors::ShoppingCartError, "Item not found"
        end
      end

      # Clear the cart, setting @items to []
      def remove_all
        @items = []
      end

      # @return [Integer] The amount in CLP of the [Item]s included in the [ShoppingCart]
      def total
        # Array#sum is Ruby 2.4+
        @items.reduce(0) { |total, item| total + item.total }
      end

      # Sum the quantity of items in the cart
      def items_quantity
        # Array#sum is Ruby 2.4+
        @items.reduce(0) { |total, item| total + item.quantity }
      end
    end
  end
end
