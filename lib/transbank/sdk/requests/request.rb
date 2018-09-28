require '../../../../lib/transbank/sdk/utils/jsonify'
require '../../../../lib/transbank/sdk/options'

# TODO: Document
module Request
  include JSONifier
  attr_accessor :api_key
  attr_accessor :app_key

  def set_keys_from_options(options)
    unless options.is_a? Options
      raise StandardError('Options parameter is not of class "Options"')
    end
    self.app_key = options.app_key
    self.api_key = options.api_key
  end
end