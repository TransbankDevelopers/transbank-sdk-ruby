require 'transbank/sdk/onepay/utils/json_utils'
require 'transbank/sdk/onepay/errors/item_error'

module Transbank
  module Onepay
    class Item
      include Utils::JSONUtils
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
      def initialize(opts = {})
        raise Errors::ItemError, 'Item must be a Hash' unless opts.is_a? Hash
        opts = transform_hash_keys opts
        self.description = opts.fetch(:description)
        self.quantity = opts.fetch(:quantity)
        self.amount = opts.fetch(:amount)
        self.additional_data = opts.fetch(:additional_data, nil)
        self.expire = opts.fetch(:expire, nil)
      end

      # @param description [String] An item's description
      # @raise [ItemError] when description is not [String]
      def description=(description)
        raise Errors::ItemError, "Description cannot be null" if description.nil?
        @description = description
      end

      # @param quantity [Integer] How many of units of [Item]
      # @raise [ItemError] when given quantity is not an [Integer] or is less than zero
      def quantity=(quantity)
        raise Errors::ItemError, "Quantity cannot be null" if quantity.nil?
        if quantity < 0
          raise Errors::ItemError, "Quantity cannot be less than zero"
        end
        @quantity = quantity
      end

      # @param amount [Integer] The value of each unit of [Item]
      # @raise [ItemError] when amount is not an [Integer] or is less than zero.
      def amount=(amount)
        raise Errors::ItemError, "Amount cannot be null" if amount.nil?
        if amount < 0
          raise Errors::ItemError, "Amount cannot be less than zero"
        end
        @amount = amount
      end

      # @param additional_data [String] A string with whatever additional data the
      # Merchant might want to add
      def additional_data=(additional_data)
        additional_data = '' if additional_data.nil?
        @additional_data = additional_data
      end

      # @param expire [Integer] Expiry for the Item
      # @raise [ItemError] if value is not an [Integer]
      def expire=(expire)
        expire = 0 if expire.nil?
        @expire = expire
      end

      def total
        self.quantity * self.amount
      end

      def ==(another_item)
        instance_variables.map! { |var| var.to_s.gsub!(/^@/, '') }
          .reduce(true) do |result, current_instance_variable|
            original_value = send(current_instance_variable)
            compared_value = another_item.send(current_instance_variable)
            next (result && true) if (original_value == compared_value)
            false
          end
      end

      def eql?(another_item)
        self.==(another_item)
      end
    end
  end
end
