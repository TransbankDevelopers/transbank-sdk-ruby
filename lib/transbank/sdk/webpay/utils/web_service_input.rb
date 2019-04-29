module Transbank
  module Webpay
    class WebServiceInput
      class << self
        def init_transaction(params)
          {
            ws_init_transaction_input: {
              'wSTransactionType': 'TR_NORMAL_WS',
              buy_order: params.fetch(:buy_order),
              session_id: params.fetch(:session_id),
              'returnURL': params.fetch(:return_url),
              'finalURL': params.fetch(:final_url),
              transaction_details: {
                amount: params.fetch(:amount),
                commerce_code: params.fetch(:commerce_code),
                buy_order: params.fetch(:buy_order)
              }
            }
          }
        end

        def transaction_result(token)
          {
            token_input: token
          }
        end

        def acknowledge_transaction(token)
          {
            token_input: token
          }
        end
      end
    end
  end
end
