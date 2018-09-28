require 'response'
require 'json'
require '../../../../lib/transbank/sdk/utils/jsonify'

class TransactionCommitResponse
  include Response, JSONifier

  attr_accessor :occ
  attr_accessor :authorization_code
  attr_accessor :signature
  attr_accessor :transaction_desc
  attr_accessor :buy_order
  attr_accessor :issued_at
  attr_accessor :amount
  attr_accessor :installments_amount
  attr_accessor :installments_number

  def initialize(json)
    from_json json
  end

  def from_json(json)
    json = JSON.parse(json) if json.is_a? String
    unless json.is_a? Hash
      raise StandardError('JSON must be a Hash (or a String decodeable to one).')
    end
    result = json['result']

    self.response_code = json['responseCode']
    self.description = json['description']
    self.occ = result['occ']
    self.authorization_code = result['authorization_code']
    self.signature = result['signature']
    self.transaction_desc = result['transactionDesc']
    self.buy_order = result['buyOrder']
    self.issued_at = result['issuedAt']
    self.amount = result['amount']
    self.installments_amount = result['installmentsAmount']
    self.installments_number = result['installmentsNumber']
    self
  end
end