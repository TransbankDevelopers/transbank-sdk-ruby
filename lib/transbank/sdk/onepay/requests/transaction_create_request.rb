module Transbank
  module Onepay
    # Create a payload to create [Transaction] on Transbank
    class TransactionCreateRequest
      include Request

      attr_accessor :external_unique_number, :total, :items_quantity, :issued_at,
                    :items, :callback_url, :channel, :app_scheme, :signature,
                    :commerce_logo_url, :width_height
      attr_reader :generate_ott_qr_code

      SIGNATURE_PARAMS = [:external_unique_number,
                          :total,
                          :items_quantity,
                          :issued_at,
                          :callback_url].freeze
      # @param opts [Hash] options hash with params needed to initialize this
      # @param external_unique_number [String] Unique identifier (per Merchant) of the [Transaction] that
      # @param total [Numeric] the total amount to pay for the items
      # @param items_quantity [Numeric] the quantity of items on the shopping cart
      # @param items [Array<Item] the items on the shopping cart
      # @param issued_at [Numeric] timestamp at the moment the transaction is created
      # @param callback_url [String] used when the channel is mobile, to be able to finish the [Transaction]
      # @param channel [String] The channel the operation is made on. Valid values
      # are on the [Channel] class
      # @param app_scheme [String] identificator for the Merchant's app
      # @param signature [String, nil] a hashstring created for verification purposes
      # @param commerce_logo_url [String] The URL pointing to the Merchant's logo
      # @param width_height [Numeric] qr width and height used by the frontend JS SDK.
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
        self.commerce_logo_url = opts.fetch(:commerce_logo_url)
        self.width_height = opts.fetch(:width_height)
        # This is never anything but true, but it is required by the server
        @generate_ott_qr_code = true
      end

      def external_unique_number=(external_unique_number)
        raise Errors::TransactionCreateError, 'External Unique Number cannot be null.' if external_unique_number.nil?
        @external_unique_number = external_unique_number
      end

      def total=(total)
        raise Errors::TransactionCreateError, 'Total cannot be null.' if total.nil?
        raise Errors::TransactionCreateError, 'Total cannot be less than zero.' if total < 0
        @total = total
      end

      def items_quantity=(items_quantity)
        raise Errors::TransactionCreateError, 'Items quantity cannot be null.' if items_quantity.nil?
        raise Errors::TransactionCreateError, 'Items quantity cannot be less than zero.' if items_quantity < 0
        @items_quantity = items_quantity
      end

      def items=(items)
        raise Errors::TransactionCreateError, 'Items must not be empty.' if items.empty?
        @items = items
      end

      def callback_url=(callback_url)
        raise Errors::TransactionCreateError, 'Callback url cannot be null.' if callback_url.nil?
        @callback_url = callback_url
      end

      def channel=(channel)
        raise Errors::TransactionCreateError, 'Channel cannot be null.' if channel.nil?
        @channel = channel
      end

      def sign(secret)
        @signature = signature_for(to_data, secret)
        self
      end
    end
  end
end
