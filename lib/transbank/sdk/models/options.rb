require 'onepay'

# The api_key that the Options object contains
# @param [String] an API key
attr_accessor :api_key
# The shared_secret the Options object contains
# @param [String] a shared secret
attr_accessor :shared_secret
# The app_key the Options object contains
# @param [String] an app key
attr_accessor :app_key
class Options
  #  Defines an options object that allows you to modify some parameters of
  # a request on a per request basis

  # @param api_key [String] Your API key, given by Transbank
  # @param shared_secret [String] your Shared secret, given by Transbank
  def initialize(api_key = nil, shared_secret = nil)
    @api_key = api_key
    @shared_secret = shared_secret
    @app_key = Onepay::current_integration_type_app_key
  end

  # Returns a new options object with Onepay::api_key as api_key and
  # Onepay::shared_secret as shared_secret
  # @return [Options] a new Options object with default values
  def self.defaults
    Options.new Onepay::api_key, Onepay::shared_secret
  end
end