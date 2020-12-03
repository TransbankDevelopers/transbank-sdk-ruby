module Transbank
  module Webpay
    module WebpayPlus
      class Base

        DEFAULT_API_KEY = '579B532A7440BB0C9079DED94D31EA1615BACEB56610332264630D42D0A36B1C'.freeze
        DEFAULT_COMMERCE_CODE = '597055555532'.freeze
        DEFAULT_DEFERRED_COMMERCE_CODE = '597055555540'.freeze

        DEFAULT_MALL_COMMERCE_CODE = '597055555535'.freeze
        DEFAULT_MALL_CHILD_COMMERCE_CODES = ['597055555536'.freeze,'597055555537'.freeze].freeze;
        DEFAULT_MALL_DEFERRED_COMMERCE_CODE = '597055555544 '.freeze
        DEFAULT_MALL_DEFERRED_CHILD_COMMERCE_CODES = ['597055555545'.freeze,
                                                      '597055555546'.freeze].freeze


        @api_key = DEFAULT_API_KEY
        @commerce_code = DEFAULT_COMMERCE_CODE
        @integration_type = :TEST
        @integration_types = {
          LIVE: "https://webpay3g.transbank.cl/",
          TEST: "https://webpay3gint.transbank.cl/"
        }
        class << self
          attr_reader :integration_types
          attr_accessor :api_key, :integration_type, :commerce_code


          def integration_type_url(integration_type)
            type = integration_type.upcase.to_sym
            return @integration_types[type] unless @integration_types[type].nil?
            valid_values = @integration_types.keys.join(', ')
            raise Transbank::Webpay::Errors::IntegrationTypeError, "Invalid integration type, valid values are #{valid_values}"
          end

          def current_integration_type_url
            @integration_types[@integration_type]
          end

          def integration_type=(integration_type)
            type = integration_type.upcase.to_sym
            return @integration_type = type unless @integration_types[type].nil?
            valid_values = @integration_types.keys.join(', ')
            raise Transbank::Webpay::Errors::IntegrationTypeError, "Invalid integration type, valid values are #{valid_values}"
          end

          def configure_for_testing
            @api_key = DEFAULT_API_KEY
            @commerce_code = DEFAULT_COMMERCE_CODE
            self.integration_type = :TEST
          end

          def configure_mall_for_testing
            @api_key = DEFAULT_API_KEY
            @commerce_code = DEFAULT_MALL_COMMERCE_CODE
            self.integration_type = :TEST
          end

          def configure_deferred_for_testing
            @api_key = DEFAULT_API_KEY
            @commerce_code = DEFAULT_DEFERRED_COMMERCE_CODE
            self.integration_type = :TEST
          end

          def configure_mall_deferred_for_testing
            @api_key = DEFAULT_API_KEY
            @commerce_code = DEFAULT_MALL_DEFERRED_COMMERCE_CODE
            self.integration_type = :TEST
          end
        end
      end
    end
  end
end
