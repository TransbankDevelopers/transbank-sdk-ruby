require 'transbank/sdk/onepay/base'
require 'transbank/sdk/onepay/requests/transaction_create_request'
require 'transbank/sdk/onepay/requests/transaction_commit_request'
require 'transbank/sdk/onepay/requests/refund_create_request'

module Transbank
  module Onepay
    module Utils
      # TODO: Complete docs for this class
      module RequestBuilder
        # Create a [Transaction] request
        def create_transaction(shopping_cart:, channel:, external_unique_number: nil, options: nil)
          Base.callback_url = Base::DEFAULT_CALLBACK  if Base.callback_url.nil?
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
          request.sign(options.fetch(:shared_secret))
        end

        # TODO: Complete documentation
        # @param occ [String]
        # @param external_unique_number [String]
        # @param options [Options]
        def commit_transaction(occ:, external_unique_number:, options: nil)
          options = complete_options(options)
          issued_at = Time.now.to_i
          request = TransactionCommitRequest.new(occ, external_unique_number, issued_at)
          request.set_keys_from_options(options)
          request.sign(options.fetch(:shared_secret))
        end

        # TODO: YARDify
        def refund_transaction(refund_amount:, occ:, external_unique_number:, authorization_code:, options: nil)
          options = complete_options(options)
          issued_at = Time.now.to_i
          request = RefundCreateRequest.new(nullify_amount: refund_amount,
                                            occ: occ,
                                            external_unique_number: external_unique_number,
                                            authorization_code: authorization_code,
                                            issued_at: issued_at)
          request.set_keys_from_options(options)
          request.sign(options.fetch(:shared_secret))
        end

        def time_as_number
          # Float#truncate(number_of_digits_to_leave) is from Ruby 2.4 onwards
          number, decimals = Time.now.to_f.to_s.split('.')
          (number + decimals[0..2]).to_i
        end

        def complete_options(options = {})
          options = {} if options.nil?
          options.merge(default_options)
        end

        def default_options
          { api_key: Base::api_key,
            app_key: Base::current_integration_type_app_key,
            shared_secret: Base::shared_secret }
        end
      end
    end
  end
end
