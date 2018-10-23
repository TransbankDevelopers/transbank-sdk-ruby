module Transbank
  module Onepay
    ## Class Transaction
    #  This class creates or commits a Transaction (that is, a purchase)
    class Transaction
      extend Utils::NetHelper, Utils::RequestBuilder

      SEND_TRANSACTION = 'sendtransaction'.freeze
      COMMIT_TRANSACTION = 'gettransactionnumber'.freeze
      TRANSACTION_BASE_PATH = '/ewallet-plugin-api-services/services/transactionservice/'.freeze

      class << self
        # Create a [Transaction], initiating the purchase process.
        # @param shopping_cart [ShoppingCart] contains the [Item]s to be purchased
        # @param channel [String] The channel that the transaction is going to be done through. Valid values are contained on the [Transbank::Onepay::Channel] class
        # @param external_unique_number [String] a unique value (per Merchant, not global) that is used to identify a Transaction
        # @param options[Hash, nil] an optional Hash with configuration overrides
        # @return [TransactionCreateResponse] the response to your request.
        # Includes data that you will need to #commit your [Transaction]
        # @raise [ShoppingCartError] if shopping cart is nil or empty
        # @raise [TransactionCreateError] if channel is not valid
        # @raise [TransactionCreateError] if no response is gotten, or responseCode of the response is not 'OK'
        def create(shopping_cart:, channel: nil, external_unique_number: nil,
                   options: nil)
          if is_options_hash?(channel)
            options = channel
            channel = nil
          end

          if is_options_hash?(external_unique_number)
            options = external_unique_number
            external_unique_number = nil
          end

          validate_channel!(channel)
          validate_shopping_cart!(shopping_cart)

          options = complete_options(options)
          create_request = create_transaction(shopping_cart: shopping_cart,
                                              channel: channel,
                                              external_unique_number: external_unique_number,
                                              options: options)
          response = http_post(transaction_create_path, create_request.to_h)
          validate_create_response!(response)
          transaction_create_response = TransactionCreateResponse.new response
          signature_is_valid = transaction_create_response.valid_signature?(options.fetch(:shared_secret))
          unless signature_is_valid
            raise Errors::SignatureError, "The response's signature is not valid."
          end
          transaction_create_response
        end

        # Commit a [Transaction]. It is MANDATORY for this to be done, and you have
        # 30 seconds to do so, otherwise the [Transaction] is automatically REVERSED
        # @param occ [String] Merchant purchase order
        # @param external_unique_number [String] a unique value (per Merchant, not global) that is used to identify a Transaction
        # @param options[Hash, nil] an optional Hash with configuration overrides
        # @return [TransactionCommitResponse] The response to your commit request.
        # @raise [TransactionCommitError] if response is nil or responseCode of the response is not 'OK'
        def commit(occ:, external_unique_number:, options: nil)
          options = complete_options(options)
          commit_request = commit_transaction(occ: occ,
                                              external_unique_number: external_unique_number,
                                              options: options)
          response = http_post(transaction_commit_path, commit_request.to_h)
          validate_commit_response!(response)
          transaction_commit_response = TransactionCommitResponse.new(response)
          signature_is_valid = transaction_commit_response.valid_signature?(options.fetch(:shared_secret))
          unless signature_is_valid
            raise Errors::SignatureError, "The response's signature is not valid."
          end
          transaction_commit_response
        end

        private

        def is_options_hash?(hash)
          return false unless hash.respond_to? :keys
          # Intersection of the two arrays
          ([:api_key, :shared_secret] & hash.keys).any?
        end

        def validate_channel!(channel)
          if channel_is_app?(channel) && Base::app_scheme.nil?
            raise Errors::TransactionCreateError, 'You need to set an app_scheme if you want to use the APP channel'
          end

          if channel_is_mobile?(channel) && Base::callback_url.nil?
            raise Errors::TransactionCreateError, 'You need to set a valid callback if you want to use the MOBILE channel'
          end
        end

        def validate_shopping_cart!(shopping_cart)
          if shopping_cart.items.nil? || shopping_cart.items.empty?
            raise Errors::ShoppingCartError, 'Shopping cart is null or empty.'
          end
        end

        def validate_commit_response!(response)
          unless response
            raise Errors::TransactionCommitError, 'Could not obtain a response from the service.'
          end

          unless response.fetch('responseCode') == 'OK'
            msg = "#{response.fetch('responseCode')} : #{response.fetch('description')}"
            raise Errors::TransactionCommitError,  msg
          end
          response
        end

        def validate_create_response!(response)
          unless response
            raise Errors::TransactionCreateError, 'Could not obtain a response from the service.'
          end

          unless response.fetch('responseCode') == 'OK'
            msg = "#{response.fetch('responseCode')} : #{response['description']}"
            raise Errors::TransactionCreateError, msg
          end
          response
        end

        def channel_is_app?(channel)
          channel && channel == Transbank::Onepay::Channel::APP
        end

        def channel_is_mobile?(channel)
          channel && channel == Transbank::Onepay::Channel::MOBILE
        end

        def transaction_create_path
          Base.current_integration_type_url + TRANSACTION_BASE_PATH + SEND_TRANSACTION
        end

        def transaction_commit_path
          Base.current_integration_type_url + TRANSACTION_BASE_PATH + COMMIT_TRANSACTION
        end
      end
    end
  end
end
