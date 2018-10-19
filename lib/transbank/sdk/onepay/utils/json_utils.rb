module Transbank
  module Onepay
    module Utils
      module JSONUtils
        def self.included(mod)
          # Implement #to_h if the class that includes this module doesn't have it
          # implemented. Used in several model classes to make them easier to
          # transform to hashes so they can be transformed to JSON afterwards
          unless mod.respond_to? :to_h
            mod.send(:define_method, :to_h) do
              JSON.parse(self.jsonify)
            end
          end
        end
        # Get all instance variables of an instance of a class,
        # then for all of these variables,
        # if the instance of the class' respond_to? returns true,
        # #send the variable name (so, you'll get the value of the instance variable's
        # getter), then save that to a Hash where [key] is the instance variable's name
        # and [value] is its value
        #
        # Finally, generate a JSON string from this hash
        # @return [String] a JSON string created from the Hash resulting from the
        # above operation
        def jsonify
          instance_vars = instance_variables.map! { |var| var.to_s.gsub!(/^@/, '') }
          instance_as_hash =
              instance_vars.reduce({}) do |resulting_hash, instance_variable|
                if respond_to? instance_variable
                  value = send(instance_variable)
                  # Safe navigation operator is Ruby 2.3+
                  value = value.to_h if value && value.respond_to?(:to_h) unless value.is_a? Array
                  value = value.to_a if value && value.respond_to?(:to_a) unless value.is_a? Hash
                  if value.is_a? Array
                    value = value.map {|x| x.respond_to?(:jsonify) ? JSON.parse(x.jsonify) : x }
                  end

                  value = value.jsonify if value.respond_to? :jsonify
                  resulting_hash[instance_variable] = value
                end
                resulting_hash
              end
          JSON.generate instance_as_hash
        end

        # Receive a Hash and return a new hash same as the one we received,
        # but all keys that were strings or camelCase'd are snake_case'd and
        # turned into symbols.
        # Example: {'camelCaseKey': "somevalue"}
        # Would return: {camel_case_key: "somevalue"}
        def transform_hash_keys(hash)
          hash.reduce({}) do |new_hsh, (key, val)|
            new_key = underscore(key).to_sym
            new_hsh[new_key] = val
            new_hsh
          end
        end

        # FROM https://stackoverflow.com/a/1509957
        # Transforms camelCaseWords to snake_case_words
        def underscore(camel_cased_word)
          camel_cased_word.to_s.gsub(/::/, '/')
              .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
              .gsub(/([a-z\d])([A-Z])/,'\1_\2')
              .tr("-", "_")
              .downcase
        end
      end
    end
  end
end


