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
          raise Errors::ItemError, "Description is not a String"
        end
        @description = description
      end

      # @param quantity [Integer] How many of units of [Item]
      # @raise [ItemError] when given quantity is not an [Integer] or is less than zero
      def quantity=(quantity)
        unless quantity.is_a? Integer
          raise Errors::ItemError, "Quantity must be an Integer"
        end

        if quantity < 0
          raise Errors::ItemError, "Quantity cannot be less than zero"
        end
        @quantity = quantity
      end

      # @param amount [Integer] The value of each unit of [Item]
      # @raise [ItemError] when amount is not an [Integer] or is less than zero.
      def amount=(amount)
        unless amount.is_a? Integer
          raise Errors::ItemError, "Amount must be an Integer"
        end

        if amount < 0
          raise Errors::ItemError, "Amount cannot be less than zero"
        end
        @amount = amount
      end

      # @param additional_data [String] A string with whatever additional data the
      # Merchant might want to add
      # @raise [ItemError] when additional_data is not a [String]
      def additional_data=(additional_data)
        additional_data = '' if additional_data.nil?
        unless additional_data.is_a? String
          raise Errors::ItemError, 'Additional data must be a String'
        end
        @additional_data = additional_data
      end

      # @param expire [Integer] Expiry for the Item
      # @raise [ItemError] if value is not an [Integer]
      def expire=(expire)
        unless expire.is_a? Integer
          raise Errors::ItemError, 'Expire must be an Integer'
        end
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

      def self.from_json(json)
       json = JSON.parse(json) if json.is_a? String
       unless json.is_a? Hash
         raise Errors::ItemError, 'json must be a Hash or a String JSON.parse\'able to one'
       end

       json = transform_hash_keys(json)
       description = json[:description]
       quantity = json[:quantity]
       amount = json[:amount]
       additional_data =  json[:additional_data]
       expire = json[:expire] || 0
       Item.new(description, quantity, amount, additional_data, expire)
       rescue JSON::ParserError
        raise Errors::ItemError, 'json must be a Hash or a String JSON.parse\'able to one'
      end

      def self.transform_hash_keys(hash)
        hash.reduce({}) do |new_hsh, (key, val)|
          new_key = underscore(key).to_sym
          new_hsh[new_key] = val
          new_hsh
        end
      end

      # FROM https://stackoverflow.com/a/1509957
      def self.underscore(camel_cased_word)
        camel_cased_word.to_s.gsub(/::/, '/')
            .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
            .gsub(/([a-z\d])([A-Z])/,'\1_\2')
            .tr("-", "_")
            .downcase
      end
    end
  end
end
