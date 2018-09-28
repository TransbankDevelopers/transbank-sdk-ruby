require "net/http"
require "../../../lib/transbank/sdk/channels"
require "../../../lib/transbank/sdk/options"
require '../../../lib/transbank/sdk/shopping_cart'

## Class Transaction
#  This class creates or commits a Transaction (that is, a purchase)
class Transaction
  SEND_TRANSACTION = 'send_transaction'.freeze
  COMMIT_TRANSACTION = 'gettransactionnumber'.freeze
  TRANSACTION_BASE_PATH = '/ewallet-plugin-api-services/services/transactionservice/'.freeze

  class << self
    ##
    # @param shopping_cart [ShoppingCart] contains the [Item]s to be purchased
    # @param channel [String] The channel that the transaction is going to be done through. Valid values are contained on the [Channel] class
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
      options =  RequestBuilder.complete_options(options)
      create_request = RequestBuilder.create_transaction(shopping_cart,
                                                         channel,
                                                         external_unique_number,
                                                         options)
      response = NetHelper.post(transaction_create_path, create_request.jsonify)

      validate_create_response!(response)
      transaction_create_response = TransactionCreateResponse.new response
      validate_signature!(transaction_create_response)
      transaction_create_response
    end

    # TODO: Document
    def commit(occ, external_unique_number, options = nil)
      options = RequestBuilder.complete_options(options)
      commit_request = RequestBuilder.commit_transaction(occ, external_unique_number, options)
      response = NetHelper.post(transaction_commit_path, commit_request.jsonify)
      validate_commit_response!(response)
      transaction_commit_response = TransactionCommitResponse.new(response)
      validate_signature!(transaction_commit_response)
      transaction_commit_response
    end

    def validate_channel!(channel)
      if channel_is_app?(channel) && Onepay::app_scheme.nil?
        raise TransactionCreateException 'You need to set an app_scheme if you want to use the APP channel'
      end

      if channel_is_mobile?(channel) && Onepay::callback_url.nil?
        raise TransactionCreateException 'You need to set a valid callback if you want to use the MOBILE channel'
      end
    end

    def validate_shopping_cart!(shopping_cart)
      unless shopping_cart.is_a? ShoppingCart
        raise ShoppingCartException 'Shopping cart must be an instance of ShoppingCart'
      end

      if shopping_cart.items.nil? || shopping_cart.items.empty?
        raise ShoppingCartException 'Shopping cart is null or empty.'
      end
    end

    def validate_signature!(response, options)
      signature_is_valid = Signer.validate(response, options.shared_secret)

      unless signature_is_valid
        raise SignatureException('The response signature is not valid.', -1)
      end
    end

    def validate_commit_response!(response)
      unless response
        raise TransactionCommitException('Could not obtain a response from the service.', -1)
      end

      unless response['responseCode'] == 'OK'
        msg = "#{response['responseCode']} : #{response['description']}"
        raise TransactionCommitException(msg, -1)
      end
    end

    def validate_create_response!(response)
      unless response
        raise TransactionCreateException('Could not obtain a response from the service.', -1)
      end

      unless response['responseCode'] == 'OK'
        msg = "#{response['responseCode']} : #{response['description']}"
        raise TransactionCreateException(msg, -1)
      end
    end

    def channel_is_app?(channel)
      channel && channel == Channel::APP
    end

    def channel_is_mobile?(channel)
      channel && channel == Channel::MOBILE
    end

    def transaction_create_path
      Onepay.current_integration_type_url + TRANSACTION_BASE_PATH + SEND_TRANSACTION
    end

    def transaction_commit_path
      Onepay.current_integration_type_url + TRANSACTION_BASE_PATH + COMMIT_TRANSACTION
    end
  end


end