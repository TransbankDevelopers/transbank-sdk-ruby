module Transbank
  module Common  
    class BaseTransaction
      
      def initialize(options)
          @commerce_code = options.commerce_code
          @api_key = options.api_key
          unless %i[production integration].include?(options.environment)
            raise ArgumentError, "Environment must be either 'integration' or 'production'"
          end
    
          @environment = options.environment
          @timeout = options.timeout
      end
    end
  end
end


