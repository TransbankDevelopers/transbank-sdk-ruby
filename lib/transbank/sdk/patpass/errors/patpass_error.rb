module Transbank
  module Patpass
    module Errors
      class PatpassError < StandardError
        attr_accessor :message, :code
        def initialize(message, code)
          self.message = message
          self.code = code
          super(message)
        end
      end
    end
  end
end