require '../../../../lib/transbank/sdk/onepay'

class RequestBuilder

  class << self
    # Create a [Transaction] request
    # @param shopping_cart [ShoppingCart] Shopping cart with the [Item]s the user
    # intends to purchase
    # @param channel [String] channel that the [Transaction] is happening through
    # valid values are on the [Channel] class
    # @param external_unique_number [String, nil] a per Merchant unique identifier for the
    # [Transaction]
    # @param options [Options, nil] an [Options] object that allows you to modify certain parameters
    # on a per request basis.
    # @return [TransactionCreateRequest] a Signed [TransactionCreateRequest]
    def create_transaction(shopping_cart, channel, external_unique_number = nil, options = nil)
      Onepay.callback_url = Onepay::DEFAULT_CALLBACK  if Onepay.callback_url.nil?
      channel = Onepay.default_channel if channel.nil?
      external_unique_number = time_as_number if external_unique_number.nil?
      options = complete_options(options)
      issued_at = Time.now.to_i

      request = TransactionCreateRequest.new(external_unique_number,
                                             shopping_cart.total,
                                             shopping_cart.item_quantities,
                                             issued_at,
                                             shopping_cart.items,
                                             Onepay.callback_url,
                                             channel,
                                             Onepay.app_scheme)
      request.set_keys_from_options(options)
      Signer.sign(request, options.shared_secret)
    end

    # TODO: Complete documentation
    # @param occ [String]
    # @param external_unique_number [String]
    # @param options [Options]
    def commit_transaction(occ, external_unique_number, options = nil)
      options = complete_options(options)
      issued_at = Time.now.to_i
      request = TransactionCommitRequest.new(occ, external_unique_number, issued_at)
      request.set_keys_from_options(options)
      Signer.sign(request, options.shared_secret)
    end

    # TODO: YARDify
    def refund_transaction(refund_amount, occ, external_unique_number, authorization_code, options = nil)
      options = complete_options(options)
      issued_at = Time.now.to_i
      request = RefundCreateRequest.new(refund_amount,
                                        occ,
                                        external_unique_number,
                                        authorization_code,
                                        issued_at)
      request.set_keys_from_options(options)
      Signer.sign(request, options.shared_secret)
    end

    def time_as_number
      (Time.now.to_f.truncate(3) * 1000).to_i
    end

    def complete_options(options)
      return Options::defaults unless options.is_a? Options
      options.api_key = Onepay::api_key if options.api_key.nil?
      options.app_key = Onepay::app_key if options.app_key.nil?
      options.shared_secret = Onepay::shared_secret if options.shared_secret.nil?
      options
    end
  end
end