require 'transbank/sdk/onepay/utils/jsonify'
require 'transbank/sdk/onepay/errors/item_error'

module Transbank
  module Onepay
    class Item
      include Utils::JSONifier
      # An Item to be purchased by the user, and to be added to a [ShoppingCart]

      # @return [String] An item's description
      attr_reader :description

      # @return quantity [Integer] How many of units of [Item]
      attr_reader :quantity

      # @return amount [Integer] The value of each unit of [Item]
      attr_reader :amount

      # @return additional_data [String] A string with whatever additional data the
      # Merchant might want to add
      attr_reader :additional_data

      # @return expire [Integer] Expiry for the Item
      attr_reader :expire
      # @param description [String] The item's description
      # @param quantity [Integer] How many of units of [Item]
      # @param amount [Integer] The value of each unit of [Item]
      # @param additional_data [String] A string with whatever additional data the
      # Merchant might want to add
      # @param expire [Integer] Expiry for the Item
      def initialize(description, quantity, amount, additional_data, expire = 0)
        self.description = description
        self.quantity = quantity
        self.amount = amount
        self.additional_data = additional_data
        self.expire = expire
      end

      # @param description [String] An item's description
      # @raise [ItemError] when description is not [String]
      def description=(description)
        unless description.is_a? String
          raise ItemError "Description is not a String"
        end
        @description = description
      end

      # @param quantity [Integer] How many of units of [Item]
      # @raise [ItemError] when given quantity is not an [Integer] or is less than zero
      def quantity=(quantity)
        unless quantity.is_a? Integer
          raise ItemError "Quantity must be an Integer"
        end

        if quantity < 0
          raise ItemError "Quantity cannot be less than zero"
        end
        @quantity = quantity
      end

      # @param amount [Integer] The value of each unit of [Item]
      # @raise [ItemError] when amount is not an [Integer] or is less than zero.
      def amount=(amount)
        unless amount.is_a? Integer
          raise ItemError "Amount must be an Integer"
        end

        if amount < 0
          raise ItemError "Amount cannot be less than zero"
        end
        @amount = amount
      end

      # @param additional_data [String] A string with whatever additional data the
      # Merchant might want to add
      # @raise [ItemError] when additional_data is not a [String]
      def additional_data=(additional_data)
        additional_data = '' if additional_data.nil?
        unless additional_data.is_a? String
          raise ItemError 'Additional data must be a String'
        end
        @additional_data = additional_data
      end

      # @param expire [Integer] Expiry for the Item
      # @raise [ItemError] if value is not an [Integer]
      def expire=(expire)
        unless expire.is_a? Integer
          raise ItemError 'Expire must be an Integer'
        end
        @expire = expire
      end
    end
  end
end
