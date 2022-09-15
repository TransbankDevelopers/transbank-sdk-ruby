require 'json'

class TransactionTest < Transbank::WebPayPlus::Test

    def setup
        @transaction_create_url = "https://webpay3gint.transbank.cl/rswebpaytransaction/api/webpay/v1.3/transactions/"
        mock_create = '{"token": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                        "url": "https://webpay3gint.transbank.cl/webpayserver/initTransaction"}'
        stub_request(:post, @transaction_create_url)
            .with(body:  /.*/ , headers: {'Content-Type' => 'application/json'})
            .to_return(status: 200, body: mock_create )

        
        @transaction_commit_url = "https://webpay3gint.transbank.cl/rswebpaytransaction/api/webpay/v1.3/transactions/token_test"
        mock_commit = '{
            "vci": "TSY",
            "amount": 10000,
            "status": "AUTHORIZED",
            "buy_order": "ordenCompra12345678",
            "session_id": "sesion1234557545",
            "card_detail": {
                "card_number": "6623"
            },
            "accounting_date": "0522",
            "transaction_date": "2019-05-22T16:41:21.063Z",
            "authorization_code": "1213",
            "payment_type_code": "VN",
            "response_code": 0,
            "installments_number": 0
          }'
        stub_request(:put, @transaction_commit_url)
            .with(body:  /.*/ , headers: {'Content-Type' => 'application/json'})
            .to_return(status: 200, body: mock_commit )
        WebMock.disable_net_connect!
    end
    
    def test_webpayplus_create_validation_success
        transaction = Transbank::Webpay::WebpayPlus::Transaction.new(Transbank::Common::IntegrationCommerceCodes::WEBPAY_PLUS,api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, :integration)
        response = transaction.create("buy_order_test", "session_id_test", 100, "http://test.com")
        assert_equal response["token"].length, Transbank::Common::ApiConstants::TOKEN_LENGTH
    end

    def test_webpayplus_create_validation_buy_order_not_ok
        buy_order_length = Transbank::Common::ApiConstants::BUY_ORDER_LENGTH 
        error= assert_raises Transbank::Shared::TransbankError do
            transaction = Transbank::Webpay::WebpayPlus::Transaction.new(Transbank::Common::IntegrationCommerceCodes::WEBPAY_PLUS,api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, :integration)
            transaction.create("A"*(buy_order_length+1), "session_id_test", 100, "http://test.com")
        end
        assert_equal error.message, 'buy_order is too long, the maximum length is %d' % buy_order_length

    end

    def test_webpayplus_create_validation_session_id_not_ok
        session_id_length = Transbank::Common::ApiConstants::SESSION_ID_LENGTH 
        error= assert_raises Transbank::Shared::TransbankError do
            transaction = Transbank::Webpay::WebpayPlus::Transaction.new(Transbank::Common::IntegrationCommerceCodes::WEBPAY_PLUS,api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, :integration)
            transaction.create("buy_order_test", "A"*(session_id_length+1), 100, "http://test.com")
        end
        assert_equal error.message, 'session_id is too long, the maximum length is %d' % Transbank::Common::ApiConstants::SESSION_ID_LENGTH 

    end

    def test_webpayplus_create_validation_return_url_not_ok
        return_url_length = Transbank::Common::ApiConstants::RETURN_URL_LENGTH 
        error= assert_raises Transbank::Shared::TransbankError do
            transaction = Transbank::Webpay::WebpayPlus::Transaction.new(Transbank::Common::IntegrationCommerceCodes::WEBPAY_PLUS,api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, :integration)
            transaction.create("buy_order_test", "session_id_test", 100, "A"*(return_url_length+1))
        end
        assert_equal error.message, 'return_url is too long, the maximum length is %d' % Transbank::Common::ApiConstants::RETURN_URL_LENGTH 
    end

    def test_webpayplus_create_validation_commit_success
        transaction = Transbank::Webpay::WebpayPlus::Transaction.new(Transbank::Common::IntegrationCommerceCodes::WEBPAY_PLUS,api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, :integration)
        response = transaction.commit("token_test")
        assert_equal response["status"], "AUTHORIZED"
    end

    def test_webpayplus_create_validation_commit_token_not_ok
        token_length = Transbank::Common::ApiConstants::TOKEN_LENGTH
        error= assert_raises Transbank::Shared::TransbankError do
            transaction = Transbank::Webpay::WebpayPlus::Transaction.new(Transbank::Common::IntegrationCommerceCodes::WEBPAY_PLUS,api_key = ::Transbank::Common::IntegrationApiKeys::WEBPAY, :integration)
            transaction.commit("A"*(token_length+1))
        end
        assert_equal error.message, 'token is too long, the maximum length is %d' % Transbank::Common::ApiConstants::TOKEN_LENGTH 
    end

    
end