require 'openssl'
require 'base64'

require 'transbank/sdk/onepay/requests/transaction_commit_request'
require 'transbank/sdk/onepay/responses/transaction_create_response'
require 'transbank/sdk/onepay/requests/transaction_create_request'
require 'transbank/sdk/onepay/responses/transaction_commit_response'
require 'transbank/sdk/onepay/responses/refund_create_response'
require 'transbank/sdk/onepay/errors/signature_error'

require 'transbank/sdk/onepay/models/transaction'
require 'transbank/sdk/onepay/requests/refund_create_request'

module Transbank
  module Onepay
    module Utils
      class Signer
        # TODO: YARD this class
        class << self
          # @param request [TransactionCommitRequest, TransactionCreateResponse, TransactionCreateRequest,TransactionCommitResponse, RefundCreateRequest] a Request that can be signed
          # @param secret [String] a string key used to create the signature
          # @raise Errors::SignatureError when the given request is not signable
          # @raise Errors::SignatureError when secret is null
          def sign(request, secret)
            raise Errors::SignatureError 'Secret cannot be null.' if secret.nil?
            if signable? request
              request.signature = signature_for(request, secret)
              return request
            end
            raise Errors::SignatureError, 'Unknown type of request'
          end

          def validate(signable, secret)
            unless signable.respond_to? :signature
              raise Errors::SignatureError('Given signable object is not validatable.')
            end
            signature = signature_for(signable, secret)
            signable.signature == signature
          end

          def signature_for(signable, secret)
            case signable
            when Transbank::Onepay::TransactionCommitRequest
              return signature_transaction_commit_request(signable, secret)
            when Transbank::Onepay::TransactionCreateResponse
              return signature_transaction_commit_request(signable, secret)
            when Transbank::Onepay::TransactionCreateRequest
              return signature_transaction_create_request(signable, secret)
            when Transbank::Onepay::TransactionCommitResponse
              return signature_transaction_commit_response(signable, secret)
            when Transbank::Onepay::RefundCreateRequest
              return signature_refund_create_request(signable, secret)
            else
              raise Errors::SignatureError, 'Unknown type of signable.'
            end
          end

          # @param signable [TransactionCommitRequest, TransactionCreateResponse]
          def signature_transaction_commit_request(signable, secret)
            unless signable.is_a?(Transbank::Onepay::TransactionCommitRequest) || signable.is_a?(Transbank::Onepay::TransactionCreateResponse)
              raise Errors::SignatureError, 'Invalid type of signable. Must be TransactionCommitRequest or TransactionCreateResponse'
            end
            if signable.occ.nil? || signable.external_unique_number.nil?
              raise Errors::SignatureError, 'occ/external_unique_number cannot be null.'
            end

            data = to_data(signable,
                           :occ,
                           :external_unique_number,
                           :issued_at)
            Base64.encode64(hmac_sha256(data, secret)).strip
          end

          def signature_transaction_create_request(signable, secret)
            raise Errors::SignatureError, 'Invalid signable. Must be a TransactionCreateRequest' unless signable.is_a? Transbank::Onepay::TransactionCreateRequest
            data = to_data(signable,
                           :external_unique_number,
                           :total,
                           :items_quantity,
                           :issued_at,
                           :callback_url)
            Base64.encode64(hmac_sha256(data, secret)).strip
          end

          def signature_transaction_commit_response(signable, secret)
            unless signable.is_a? Transbank::Onepay::TransactionCommitResponse
              raise Errors::SignatureError, 'Invalid signable. Must be: TransactionCommitResponse.'
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
            unless signable.is_a? Transbank::Onepay::RefundCreateRequest
              raise Errors::SignatureError, 'Invalid type of signable. Must be RefundCreateRequest'
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
              value_of_getter = signable.send(current_value)
              # Integer#digits is ruby 2.4 upwards :(
              data_string + value_of_getter.to_s.length.to_s + value_of_getter.to_s
            end
          end

          def hmac_sha256(data, secret)
            OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret, data)
          end

          def signable?(request)
            valid_class =
                [Transbank::Onepay::RefundCreateRequest,
                 Transbank::Onepay::TransactionCommitResponse,
                 Transbank::Onepay::TransactionCreateRequest,
                 Transbank::Onepay::TransactionCreateResponse,
                 Transbank::Onepay::TransactionCommitRequest].include? request.class
            is_signable = request.respond_to? :signature=
            valid_class && is_signable
          end
        end
      end
    end
  end
end
