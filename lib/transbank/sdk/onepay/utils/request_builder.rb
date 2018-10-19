module Transbank
  module Onepay
    module Utils
      module RequestBuilder
        # Create a [Transaction] request. Used internally by [Transaction]#create
        # @param shopping_cart [ShoppingCart] the user's ShoppingCart, with [Item]s
        # he/she intends to purchase
        # @param channel [String] The channel the operation is made on. Valid values
        # are on the [Channel] class
        # @param external_unique_number [String, nil] a unique value (per Merchant, not global) that is used to identify a Transaction
        # @param options [Hash, nil] a hash with config overrides
        def create_transaction(shopping_cart:, channel:, external_unique_number: nil, options: nil)
          channel = Base.default_channel if channel.nil?
          external_unique_number = time_as_number if external_unique_number.nil?
          options = complete_options(options)
          issued_at = Time.now.to_i

          request = TransactionCreateRequest.new(external_unique_number: external_unique_number,
                                                 total: shopping_cart.total,
                                                 items_quantity: shopping_cart.items_quantity,
                                                 issued_at: issued_at,
                                                 items: shopping_cart.items,
                                                 callback_url: Base.callback_url,
                                                 channel: channel,
                                                 app_scheme: Base.app_scheme)
          request.set_keys_from_options(options)
          request.app_key = Base::current_integration_type_app_key
          request.sign(options.fetch(:shared_secret))
        end

        # Used internally by [Transaction]#commit
        # @param occ [String] Merchant purchase order
        # @param external_unique_number [String] a unique value (per Merchant, not global) that is used to identify a Transaction
        # @param options [Hash, nil] a hash with config overrides
        def commit_transaction(occ:, external_unique_number:, options: nil)
          options = complete_options(options)
          issued_at = Time.now.to_i
          request = TransactionCommitRequest.new(occ, external_unique_number, issued_at)
          request.set_keys_from_options(options)
          request.app_key = Base::current_integration_type_app_key
          request.sign(options.fetch(:shared_secret))
        end

        # Used internally by [Refund]#create
        # @param refund_amount [Integer] the full amount of the [Transaction] to refund. No partial refunds allowed.
        # @param occ [String] Merchant purchase order of the order to refund
        # @param external_unique_number [String] external unique number of the [Transaction] to refund
        # @param authorization_code [String] authorization code for the [Transaction] to refund.
        # This is given when you successfully #commit a [Transaction]
        # @param options [Hash, nil] a hash with config overrides
        def refund_transaction(refund_amount:, occ:, external_unique_number:, authorization_code:, options: nil)
          options = complete_options(options)
          issued_at = Time.now.to_i
          request = RefundCreateRequest.new(nullify_amount: refund_amount,
                                            occ: occ,
                                            external_unique_number: external_unique_number,
                                            authorization_code: authorization_code,
                                            issued_at: issued_at)
          request.set_keys_from_options(options)
          request.app_key = Base::current_integration_type_app_key
          request.sign(options.fetch(:shared_secret))
        end

        def time_as_number
          # Float#truncate(number_of_digits_to_leave) is from Ruby 2.4 onwards
          number, decimals = Time.now.to_f.to_s.split('.')
          (number + decimals[0..2]).to_i
        end

        # Fill options with default values
        def complete_options(options = {})
          options = {} if options.nil?
          default_options.merge(options)
        end

        # Return the default options values:
        # api_key: Base::api_key
        # app_key: Base::current_integration_type_app_key
        # shared_secret: Base::shared_secret
        # @return [Hash] a hash with the aforementioned keys/values
        def default_options
          { api_key: Base::api_key,
            shared_secret: Base::shared_secret }
        end
      end
    end
  end
end
