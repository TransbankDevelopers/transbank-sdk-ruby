module Transbank
    module Common  
      class BaseTransaction
        
        def initialize(commerce_code = ::Transbank::Common::IntegrationCommerceCodes::WEBPAY_PLUS, api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, environment = DEFAULT_ENVIRONMENT)
            @commerce_code = commerce_code
            @api_key = api_key
            unless %i[production integration].include?(environment)
              raise ArgumentError, "Environment must be either 'integration' or 'production'"
            end
      
            @environment = environment
        end
      end
    end
  end
  
  
  