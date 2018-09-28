class TransbankException < StandardError
  def initialize(msg, error_code)
    @msg = msg
    @code = error_code
  end
end