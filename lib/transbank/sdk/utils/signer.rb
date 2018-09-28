require 'openssl'
require 'base64'

require '../../../../lib/transbank/sdk/requests/transaction_create_request'

class Signer
  class << self
    # @param request [TransactionCommitRequest, TransactionCreateResponse, TransactionCreateRequest,TransactionCommitResponse, RefundCreateRequest] a Request that can be signed
    # @param secret [String] a string key used to create the signature
    # @raise StandardError when the given request is not signable
    # @raise StandardError when secret is null
    def sign(request, secret)
      raise StandardError('Secret cannot be null.') if secret.nil?
      if signable? request
        request.signature = signature_for(request, secret)
        return request
      end
      raise StandardError('Unknown type of request')
    end

    def validate(signable, secret)
      unless signable.respond_to? :signature
        raise StandardError('Given signable object is not validatable.')
      end
      signature = signature_for(signable, secret)
      signable.signature == signature
    end

    def signature_for(signable, secret)
      case signable.class
      when TransactionCommitRequest || TransactionCreateResponse
        return signature_transaction_commit_request(signable, secret)
      when TransactionCreateRequest
        return signature_transaction_create_request(signable, secret)
      when TransactionCommitResponse
        return signature_transaction_commit_response(signable, secret)
      when RefundCreateRequest
        return signature_refund_create_request(signable, secret)
      else
        raise StandardError('Unknown type of signable.')
      end
    end

    # @param signable [TransactionCommitRequest, TransactionCreateResponse]
    def signature_transaction_commit_request(signable, secret)
      unless signable.is_a?(TransactionCommitRequest) || signable.is_a?(TransactionCreateResponse)
        raise StandardError('Invalid type of signable. Must be TransactionCommitRequest or TransactionCreateResponse')
      end
      if signable.occ.nil? || signable.external_unique_number.nil?
        raise StandardError('occ/external_unique_number cannot be null.')
      end

      data = to_data(signable.occ, signable.external_unique_number, signable.issued_at)
      Base64.encode64(hmac_sha256(data, secret)).strip
    end

    def signature_transaction_create_request(signable, secret)
      raise StandardError('Invalid signable. Must be a TransactionCreateRequest') unless signable.is_a? TransactionCreateRequest
      data = to_data(signable,
                     :external_unique_number,
                     :total,
                     :item_quantity,
                     :issued_at,
                     :callback_url)
      Base64.encode64(hmac_sha256(data, secret)).strip
    end

    def signature_transaction_commit_response(signable, secret)
      unless signable.is_a? TransactionCommitResponse
        raise StandardError('Invalid signable. Must be: TransactionCommitResponse.')
      end

      data = to_data(signable,
                     :occ,
                     :authorization_code,
                     :issued_at,
                     :amount,
                     :installments_amount,
                     :installments_number,
                     :buy_order)

      Base64.encode64(hmac_sha256(data, secret)).strip
    end

    def signature_refund_create_request(signable, secret)
      unless signable.is_a? RefundCreateRequest
        raise StandardError('Invalid type of signable. Must be RefundCreateRequest')
      end

      data = to_data(signable,
                     :occ,
                     :external_unique_number,
                     :authorization_code,
                     :issued_at,
                     :refund_amount)
      Base64.encode64(hmac_sha256(data, secret)).strip
    end

    # @param signable [TransactionCreateRequest, TransactionCreateResponse, TransactionCommitRequest, TransacttionCommitResponse, RefundCreateRequest] A signable object
    # @param values [Array<Symbol>] methods that signable implements, that will return some value to be used when signing
    def to_data(signable, *values)
      values.reduce('') do |data_string, current_value|
        data_string + signable.send(current_value).size.to_s + signable.send(current_value).to_s
      end
    end

    def hmac_sha256(data, secret)
      OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret, data)
    end

    def signable?(request)
      valid_class =
          [RefundCreateRequest,
           TransactionCommitResponse,
           TransactionCreateRequest,
           TransactionCreateResponse,
           TransactionCommitRequest].include? request.class
      signable = request.respond_to? :signature=
      valid_class && signable
    end
  end
end