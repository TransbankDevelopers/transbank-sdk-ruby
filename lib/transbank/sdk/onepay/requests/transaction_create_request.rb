require 'transbank/sdk/onepay/requests/request'
require 'transbank/sdk/onepay/models/channels'

module Transbank
  module Onepay
    class TransactionCreateRequest
      include Request

      attr_accessor :external_unique_number, :total, :items_quantity, :issued_at,
                    :items, :callback_url, :channel, :app_scheme, :signature

      SIGNATURE_PARAMS = [:external_unique_number,
                          :total,
                          :items_quantity,
                          :issued_at,
                          :callback_url].freeze
      def initialize(opts = {})
        self.external_unique_number = opts.fetch(:external_unique_number)
        self.total = opts.fetch(:total)
        self.items_quantity = opts.fetch(:items_quantity)
        self.items = opts.fetch(:items)
        self.issued_at = opts.fetch(:issued_at)
        self.callback_url = opts.fetch(:callback_url)
        channel = opts.fetch(:channel, Channel::WEB)
        self.channel = channel
        self.app_scheme = opts.fetch(:app_scheme, '')
        self.signature = nil
      end

      def external_unique_number=(external_unique_number)
        raise TransactionCreateError, 'External Unique Number cannot be null.' if external_unique_number.nil?
        @external_unique_number = external_unique_number
      end

      def total=(total)
        raise TransactionCreateError, 'Total cannot be null.' if total.nil?
        raise TransactionCreateError, 'Total cannot be less than zero.' if total < 0
        @total = total
      end

      def items_quantity=(items_quantity)
        raise TransactionCreateError, 'Items quantity cannot be null.' if items_quantity.nil?
        raise TransactionCreateError, 'Items quantity cannot be less than zero.' if items_quantity < 0
        @items_quantity = items_quantity
      end

      def items=(items)
        raise TransactionCreateError, 'Items must not be empty.' if items.empty?
        @items = items
      end

      def callback_url=(callback_url)
        raise TransactionCreateError, 'Callback url cannot be null.' if callback_url.nil?
        @callback_url = callback_url
      end

      def channel=(channel)
        raise TransactionCreateError, 'Channel cannot be null.' if channel.nil?
        channel
      end

      def sign(secret)
        @signature = signature_for(to_data, secret)
        self
      end
    end
  end
end
