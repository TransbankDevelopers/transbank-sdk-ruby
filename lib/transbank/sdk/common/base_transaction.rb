module Transbank
  module Common  
    class BaseTransaction
      
      def initialize(options)
          required_methods = [:commerce_code, :api_key, :environment, :timeout]
          missing_methods = required_methods.reject { |method| options.respond_to?(method) }

          unless missing_methods.empty?
            raise ArgumentError, "Options object must respond to: #{missing_methods.join(', ')}"
          end
          unless %i[production integration].include?(options.environment)
            raise ArgumentError, "Environment must be either 'integration' or 'production'"
          end
          
          @commerce_code = options.commerce_code
          @api_key = options.api_key
    
          @environment = options.environment
          @timeout = options.timeout
      end
    end
  end
end


