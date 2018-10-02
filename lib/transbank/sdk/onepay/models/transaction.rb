require "net/http"
require "transbank/sdk/onepay/models/channels"
require "transbank/sdk/onepay/models/options"
require 'transbank/sdk/onepay/models/shopping_cart'
require 'transbank/sdk/onepay/utils/net_helper'
require 'transbank/sdk/onepay/utils/request_builder'
require 'transbank/sdk/onepay/base'
require 'transbank/sdk/onepay/errors/transaction_create_error'
require 'transbank/sdk/onepay/errors/signature_error'
require 'transbank/sdk/onepay/errors/shopping_cart_error'
require 'transbank/sdk/onepay/errors/transaction_commit_error'
require 'transbank/sdk/onepay/utils/signer'

module Transbank
  module Onepay
    ## Class Transaction
    #  This class creates or commits a Transaction (that is, a purchase)
    class Transaction
      SEND_TRANSACTION = 'sendtransaction'.freeze
      COMMIT_TRANSACTION = 'gettransactionnumber'.freeze
      TRANSACTION_BASE_PATH = '/ewallet-plugin-api-services/services/transactionservice/'.freeze

      class << self
        ##
        # @param shopping_cart [ShoppingCart] contains the [Item]s to be purchased
        # @param channel [String] The channel that the transaction is going to be done through. Valid values are contained on the [Transbank::Onepay::Channel] class
        # @param external_unique_number [String] a unique value (per Merchant, not global) that is used to identify a Transaction
        # @param options [Options] An [Options] object.
        def create(shopping_cart, channel = nil,
                   external_unique_number = nil, options = nil)

          if channel.is_a? Options
            options = channel
            channel = nil
          end

          if external_unique_number.is_a? Options
            options = external_unique_number
            external_unique_number = nil
          end

          validate_channel!(channel)
          validate_shopping_cart!(shopping_cart)
          options = Utils::RequestBuilder.complete_options(options)
          create_request = Utils::RequestBuilder.create_transaction(shopping_cart,
                                                             channel,
                                                             external_unique_number,
                                                             options)
          response = Utils::NetHelper.post(transaction_create_path, JSON.parse(create_request.jsonify))

          validate_create_response!(response)
          transaction_create_response = TransactionCreateResponse.new response
          validate_signature!(transaction_create_response, options)
          transaction_create_response
        end

        # TODO: Document
        def commit(occ, external_unique_number, options = nil)
          options = Utils::RequestBuilder.complete_options(options)
          commit_request = Utils::RequestBuilder.commit_transaction(occ, external_unique_number, options)
          response = Utils::NetHelper.post(transaction_commit_path, JSON.parse(commit_request.jsonify))
          validate_commit_response!(response)
          transaction_commit_response = TransactionCommitResponse.new(response)
          validate_signature!(transaction_commit_response, options)
          transaction_commit_response
        end


        private

        def validate_channel!(channel)
          if channel_is_app?(channel) && Base::app_scheme.nil?
            raise Errors::TransactionCreateError, 'You need to set an app_scheme if you want to use the APP channel'
          end

          if channel_is_mobile?(channel) && Base::callback_url.nil?
            raise Errors::TransactionCreateError, 'You need to set a valid callback if you want to use the MOBILE channel'
          end
        end

        def validate_shopping_cart!(shopping_cart)
          unless shopping_cart.is_a? ShoppingCart
            raise Errors::ShoppingCartError, 'Shopping cart must be an instance of ShoppingCart'
          end

          if shopping_cart.items.nil? || shopping_cart.items.empty?
            raise Errors::ShoppingCartError, 'Shopping cart is null or empty.'
          end
        end

        def validate_signature!(response, options)
          signature_is_valid = Utils::Signer.validate(response, options.shared_secret)

          unless signature_is_valid
            raise Errors::SignatureError, 'The response signature is not valid.'
          end
        end

        def validate_commit_response!(response)
          unless response
            raise Errors::TransactionCommitError, 'Could not obtain a response from the service.'
          end

          unless response['responseCode'] == 'OK'
            msg = "#{response['responseCode']} : #{response['description']}"
            raise Errors::TransactionCommitError,  msg
          end
          response
        end

        def validate_create_response!(response)
          unless response
            raise Errors::TransactionCreateError, 'Could not obtain a response from the service.'
          end

          unless response['responseCode'] == 'OK'
            msg = "#{response['responseCode']} : #{response['description']}"
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
