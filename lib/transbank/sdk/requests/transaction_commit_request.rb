require 'request'
class TransactionCommitRequest
  include Request
  attr_reader :occ
  attr_reader :external_unique_number
  attr_reader :issued_at
  attr_accessor :signature
  # @param occ [String] Merchant purchase order
  # @param external_unique_number [String] a unique value (per Merchant, not global) that is used to identify a Transaction
  # @param issued_at [Integer] timestamp for when the transaction commit request was created
  def initialize(occ, external_unique_number, issued_at)
    self.occ = occ
    self.external_unique_number = external_unique_number
    @issued_at = issued_at
    @signature = nil
  end

  # @param occ [String] Merchant purchase order
  def occ=(occ)
    raise StandardError('occ cannot be null.') if occ.nil?
    @occ = occ
  end

  # @param external_unique_number [String] a unique value (per Merchant, not global) that is used to identify a Transaction
  def external_unique_number=(external_unique_number)
    raise StandardError('external_unique_number cannot be null.') if external_unique_number.nil?
    @external_unique_number = external_unique_number
  end

  # @param issued_at [Integer] timestamp for when the transaction commit request was created
  def issued_at=(issued_at)
    raise StandardError('issued_at cannot be null.') if issued_at.nil?
    @issued_at = issued_at
  end

end