module Transbank
  module Webpay
    module WebServiceOutput
      class InitTransaction
        attr_accessor :url
        attr_accessor :token

        def initialize(params)
          self.url = params.fetch(:url)
          self.token = params.fetch(:token)
        end
      end

      class TransactionResult
        ACCESSORS = %i[
          accounting_date buy_order card_detail detail_output
          session_id transaction_date url_redirection vci
        ].freeze
        attr_accessor(*ACCESSORS)

        def initialize(params)
          ACCESSORS.each do |symbol|
            instance_variable_set(
              "@#{symbol}".to_sym, params.fetch(symbol)
            )
          end
        end
      end

      class CardDetail
        attr_accessor :card_number

        def initialize(params)
          params.fetch(:card_number)
        end
      end

      class DetailOutput
        ACCESSORS = %i[
          shares_number amount commerce_code buy_order
          authorization_code payment_type_code response_code
        ].freeze
        attr_accessor(*ACCESSORS)

        def initialize(params)
          ACCESSORS.each do |symbol|
            instance_variable_set(
              "@#{symbol}".to_sym, params.fetch(symbol)
            )
          end
        end
      end
    end
  end
end
