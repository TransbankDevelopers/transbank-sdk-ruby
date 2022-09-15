
module Transbank
    module Common  
      class Validation
        
        def self.has_text_with_max_length(value, value_max_length,  value_name)
          if value.nil? || value.empty? 
            raise Transbank::Shared::TransbankError, "Transbank Error: %s is empty" % [value_name]
          end
          if value.length() > value_max_length
            raise Transbank::Shared::TransbankError, "%s is too long, the maximum length is %s"% [value_name, value_max_length]
          end
        end
      end
    end
end
  
  
  