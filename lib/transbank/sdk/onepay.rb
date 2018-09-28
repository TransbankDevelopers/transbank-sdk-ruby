class Onepay
  #  The base class for Transbank Onepay
  DEFAULT_CALLBACK = "http://no.callback.has/been.set".freeze
  DEFAULT_API_KEY = 'dKVhq1WGt_XapIYirTXNyUKoWTDFfxaEV63-O5jcsdw'.freeze
  DEFAULT_SHARED_SECRET = '?XW#WOLG##FBAGEAYSNQ5APD#JF@$AYZ'.freeze

  @app_keys = {'TEST': '1a0c0639-bd2f-4846-8d26-81f43187e797',
                'LIVE': '2B571C49-C1B6-4AD1-9806-592AC68023B7',
                'MOCK': '04533c31-fe7e-43ed-bbc4-1c8ab1538afp'}.freeze
  @integration_types = {"TEST": 'https://onepay.ionix.cl'.freeze,
                        "LIVE": 'https://www.onepay.cl'.freeze,
                        "MOCK": 'http://onepay.getsandbox.com'.freeze}.freeze
  @callback_url = nil
  @api_key = default_api_key
  @shared_secret = default_shared_secret

  @integration_type = 'TEST'
  @app_scheme = nil
  @default_channel = Channel::WEB

  class << self

    # Contains all valid integration types
    # @return [Hash<String, String>]
    attr_reader :integration_types

    # Your Api key, given by Transbank
    # @return [String]
    attr_accessor :api_key

    # Your callback URL, used to resume the payment process after validating with
    # Transbank when paying on Channel::MOBILE
    # @param [String]
    # @return [String]
    attr_accessor :callback_url

    # Your shared secret, given by Transbank
    # @param [String]
    # @return [String]
    attr_accessor :shared_secret

    # The current integration type
    # @param [String]
    # @return [String]
    attr_reader :integration_type

    # The URI for the app (eg the Android Intent that starts the app/the iOS
    # equivalent)
    # @param [String]
    # @return [String]
    attr_writer :app_scheme

    # The default channel. Value must be in Channel.values
    # @return [String] One of the values from Channel.values
    attr_reader :default_channel

    # @return [String] the URL that is used by the current integration type
    def current_integration_type_url
      @integration_types[@integration_type]
    end

    # @return [String] the app key used by the current integration type
    def current_integration_type_app_key
      @app_keys[@integration_type]
    end

    # Sets the current integration type
    # @param type [String] Type of integration to be set. Must be included one
    # of the keys of self.integration_types
    # @raise [StandardError] if the given type is not valid
    def integration_type=(type)
      return @integration_type = type unless @integration_types[type].nil?
      valid_values = @integration_types.keys.join(', ')
      raise StandardError "Invalid integration type, valid values are #{valid_values}"
    end

    # Returns the app_scheme
    # @return [String] the app scheme, either the one set on @app_scheme or,
    # failing that, the value of ENV['ONEPAY_APP_SCHEME'] (your env variable)
    def app_scheme
      return ENV['ONEPAY_APP_SCHEME'] unless @app_scheme
      @app_scheme
    end

    # Returns the 'ONEPAY_API_KEY' env variable, or, if ONEPAY_API_KEY
    # doesn't exist, returns a default api key
    # @return [String] ENV['ONEPAY_API_KEY] or DEFAULT_API_KEY
    def default_api_key
      env_api_key = ENV['ONEPAY_API_KEY']
      env_api_key.nil? ? DEFAULT_API_KEY : env_api_key
    end

    # Returns the 'ONEPAY_SHARED_SECRET' env variable, or, if ONEPAY_SHARED_SECRET
    # doesn't exist, returns a default shared secret
    # @return [String] ENV['ONEPAY_SHARED_SECRET'] or DEFAULT_SHARED_SECRET
    def default_shared_secret
      env_shared_secret = ENV['ONEPAY_SHARED_SECRET']
      env_shared_secret.nil? ? DEFAULT_SHARED_SECRET : env_shared_secret
    end
  end

end