module Transbank
  module Webpay
    module Oneclick
      class MallBinInfo < ::Transbank::Common::BaseTransaction
        private_class_method :new
        RESOURCES_URL = ::Transbank::Common::ApiConstants::ONECLICK_ENDPOINT
        QUERY_BIN_ENDPOINT = (RESOURCES_URL + '/bin_info').freeze
    
        def initialize(options)
          super
        end

        def self.new(options)
          super(options)
        end

        def self.build_for_integration(commerce_code, api_key)
          options = Options.new(
            commerce_code,
            api_key,
            :integration
          )
          
          new(options)
        end

        def self.build_for_production(commerce_code, api_key)
          options = Options.new(
            commerce_code,
            api_key,
            :production
          )
          new(options)
        end
    
        def query_bin(tbk_user)
          Transbank::Common::Validation.has_text_with_max_length(tbk_user, Transbank::Common::ApiConstants::TBK_USER_LENGTH, "tbk_user")

          request_service = ::Transbank::Shared::RequestService.new(
            @environment, QUERY_BIN_ENDPOINT, @commerce_code, @api_key, @timeout
          )
          request_service.post({ tbk_user: tbk_user })
        end

      end  
    end
  end
end
