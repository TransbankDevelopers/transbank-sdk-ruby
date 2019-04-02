require 'transbank/sdk/onepay/base'
require 'transbank/sdk_test'
require 'transbank/sdk/onepay/models/transaction'
require 'transbank/onepay/mocks/shopping_cart_mocks'
require 'json'

class TransactionTest < Transbank::Onepay::Test
  EXTERNAL_UNIQUE_NUMBER_TO_COMMIT_TRANSACTION_TEST = "1532376544050";
  OCC_TO_COMMIT_TRANSACTION_TEST = "1807829988419927";

  def setup
    Transbank::Onepay::Base.shared_secret = "P4DCPS55QB2QLT56SQH6#W#LV76IAPYX"
    Transbank::Onepay::Base.api_key = "mUc0GxYGor6X8u-_oB3e-HWJulRG01WoC96-_tUA3Bg"
    Transbank::Onepay::Base.integration_type = "MOCK"
    @integration_url = Transbank::Onepay::Base.current_integration_type_url
    @transaction_create_url = Transbank::Onepay::Transaction.send(:transaction_create_path)
    @transaction_commit_url = Transbank::Onepay::Transaction.send(:transaction_commit_path)
    WebMock.disable_net_connect!
  end

  def test_transaction_raises_when_response_is_empty
    stub_request(:post, @transaction_create_url)
        .with(body:  /.*/ , headers: {'Content-Type' => 'application/json'})
        .to_return(status: 200, body: "{}" )
    cart = Transbank::Onepay::Mocks::ShoppingCartMocks[0]

    error =
        assert_raises KeyError do
          Transbank::Onepay::Transaction.create(shopping_cart: cart)
        end
    assert_equal error.message, "key not found: \"responseCode\""
  end

  def test_transaction_raises_when_response_is_not_ok
    mock_response = JSON.generate(
                     :responseCode => 'INVALID_PARAMS',
                     :description => 'Parametros invalidos',
                     :result => nil
                    )
    stub_request(:post, @transaction_create_url)
        .with(body:  /.*/ , headers: {'Content-Type' => 'application/json'})
        .to_return(status: 200, body: mock_response)

    cart = Transbank::Onepay::Mocks::ShoppingCartMocks[0]
    error =
      assert_raises Transbank::Onepay::Errors::TransactionCreateError  do
        Transbank::Onepay::Transaction.create(shopping_cart: cart)
      end
    assert_equal error.message, 'INVALID_PARAMS : Parametros invalidos'
  end

  def test_transaction_raises_when_signature_is_invalid
    mock_response =
        '{
            "responseCode": "OK",
            "description": "OK",
            "result": {
                "occ": "1807216892091979",
                "ott": 51435450,
                "signature": "FAKE SIGNATURE",
                "externalUniqueNumber": "1532103675510",
                "issuedAt": 1532103850,
                "qrCodeAsBase64": "iVBORw0KGgoAAAANSUhEUgAAAMgAAADICAYAAACtWK6eAAADqElEQVR42u3dQW7DMBAEQf3/08kLcgggame41UBugSGLLB8Wlvn8SPqzxy2QAJEAkQCRAJEAkQCRAJEAkQCRBIgEiASIBIgEiASIBIgEiASIBIgkQCRAJEAkQKQtQJ7nqfj77/W3/P+29QIEEEAAAQQQQAABBBBAAAEEEEAAefeGj43uXrqeGzbApvUCBBDrBQgg1gsQQAABBBBAAAEEEEDefYMtY9vTG34KVPt6AQIIIIAAAggggAACCCCAAAIIIIAA8uX1pL0OIIAAAggggAACCCCAAAIIIIAAAgggjUDSxrZTrwMIIIAAAggggAACCCCAAAIIIIAAshNI+/W0bwyP3AICiPUCBBDrBQgg1gsQQAABBBBAAHH8Qe//O/4AEEAAAcSGBwQQQAABBBBAAAEEkLuBbGvboZ9Xr6VbAIgAAQQQQAABBBBAAAEEEEAWAUkb97WPSacgn36/icABAQQQQAABBBBAAAEEEEAAAQSQTUCmNtKtxwe0jKONeQEBBBBAAAEEEEAAAQQQQAABBJA7xrxp48d24FMbO/FRWUAAAQQQQAABBBBAAAEEEEAAAQSQOSAtX2JMO7ag/XqcDwIIIIAAAggggAACCCCAAAIIIIBkPnKbNlZtOV4h7T7fMBYGBBBAAAEEEEAAAQQQQAABBBBANgFpH1e2f1Ccvs6WL5cCAggggAACCCCAAAIIIIAAAggggLy7YdIWtGX8e3qMPDWmXjvmBQQQQAABBBBAAAEEEEAAAQQQQD4G0n4cQMsPwbWPYQEBBBBAAAEEEEAAAQQQQAABBBBAMse8UzeqZew59YHT8ogxIIAAAggggAACCCCAAAIIIIAAAoiSF3RqzNvygQAIIIAAAggggAACCCCAAAIIIIAAMrugaV8aPL2gLWNVPxwHCCCAAAIIIIAAAggggAACCCCA3A2kZWybNg5tHzs37R9AAAEEEEAAAQQQQAABBBBAAAEEkPOPiKZtmLQxb/s4HRBAAAEEEEAAAQQQQAABBBBAAAEEkC+vJ25TlP8wHSCAAAIIIIAAAggggAACCCCAAAIIIAkL136Y6dT7AgQQQAABBBBAAAEEEEAAAQQQQACZXdBbx5i3bsimMTgggAACCCCAAAIIIIAAAggggAACSP9GuvUwzZb7CQgggAACCCCAAAIIIIAAAggggAAiCRAJEAkQCRAJEAkQCRAJEAkQCRBJgEiASIBIgEiASIBIgEiASIBIAkQCRAJEAkQCRErpF7hX1b0GLrAmAAAAAElFTkSuQmCC"
            }
        }'
    cart = Transbank::Onepay::Mocks::ShoppingCartMocks[0]
    stub_request(:post, @transaction_create_url)
        .with(body:  /.*/ , headers: {'Content-Type' => 'application/json'})
        .to_return(status: 200, body: mock_response)
    error =
      assert_raises Transbank::Onepay::Errors::SignatureError do
        Transbank::Onepay::Transaction.create(shopping_cart: cart)
      end
    assert_equal error.message, "The response's signature is not valid."
  end

  def test_transaction_creation_works_taking_keys_from_env
    # This uses the MOCK environment
    WebMock.allow_net_connect!
    original_api_key = Transbank::Onepay::Base.api_key
    original_shared_secret = Transbank::Onepay::Base.shared_secret

    Transbank::Onepay::Base.api_key = nil
    Transbank::Onepay::Base.shared_secret = nil

    ENV['ONEPAY_API_KEY'] = original_api_key
    ENV['ONEPAY_SHARED_SECRET'] = original_shared_secret

    assert_equal ENV['ONEPAY_API_KEY'], Transbank::Onepay::Base.api_key
    assert_equal ENV['ONEPAY_SHARED_SECRET'], Transbank::Onepay::Base.shared_secret

    cart = Transbank::Onepay::Mocks::ShoppingCartMocks[0]
    response = Transbank::Onepay::Transaction.create(shopping_cart: cart)

    assert_equal response.response_code, "OK"
    assert_equal response.description, "OK"
    refute_nil response.qr_code_as_base64
  end

  def test_transaction_creation_works_without_options
    # This uses the MOCK environment
    WebMock.allow_net_connect!
    cart = Transbank::Onepay::Mocks::ShoppingCartMocks[0]
    response = Transbank::Onepay::Transaction.create(shopping_cart: cart)

    assert response.is_a?(Transbank::Onepay::TransactionCreateResponse)
    assert_equal response.response_code, "OK"
    assert_equal response.description, "OK"
    refute_nil response.qr_code_as_base64
  end

  def test_transaction_creation_works_with_options
    WebMock.allow_net_connect!
    cart = Transbank::Onepay::ShoppingCart.new
    options = {api_key: "mUc0GxYGor6X8u-_oB3e-HWJulRG01WoC96-_tUA3Bg",
               shared_secret: "P4DCPS55QB2QLT56SQH6#W#LV76IAPYX"}
    first_item = Transbank::Onepay::Item.new(description: "Zapatos", quantity: 1, amount: 15000, additional_data: nil, expire: -1)
    second_item = Transbank::Onepay::Item.new(description: "Pantalon", quantity: 1, amount: 12500, additional_data:  nil, expire: -1)

    cart << first_item
    cart.add(second_item)

    assert_equal first_item.description, "Zapatos"
    assert_equal second_item.description, "Pantalon"

    response = Transbank::Onepay::Transaction.create(shopping_cart: cart, options: options)
    assert response.is_a?(Transbank::Onepay::TransactionCreateResponse)
    assert_equal response.response_code, "OK"
    assert_equal response.description, "OK"
    refute_nil response.qr_code_as_base64
  end

  def test_transaction_commit_works_with_options
    WebMock.allow_net_connect!
    options = {api_key:"mUc0GxYGor6X8u-_oB3e-HWJulRG01WoC96-_tUA3Bg",
               shared_secret: "P4DCPS55QB2QLT56SQH6#W#LV76IAPYX"}

    response = Transbank::Onepay::Transaction.commit(occ: OCC_TO_COMMIT_TRANSACTION_TEST,
                                                     external_unique_number: EXTERNAL_UNIQUE_NUMBER_TO_COMMIT_TRANSACTION_TEST,
                                                     options: options)
    assert response.is_a?(Transbank::Onepay::TransactionCommitResponse)
    assert_equal response.response_code, "OK"
    assert_equal response.description, "OK"
  end

  def test_transaction_commit_works_without_options
    WebMock.allow_net_connect!
    response = Transbank::Onepay::Transaction.commit(occ: OCC_TO_COMMIT_TRANSACTION_TEST,
                                                     external_unique_number: EXTERNAL_UNIQUE_NUMBER_TO_COMMIT_TRANSACTION_TEST)
    assert response.is_a?(Transbank::Onepay::TransactionCommitResponse)
    assert_equal response.response_code, "OK"
    assert_equal response.description, "OK"
  end

  def test_transaction_commit_raises_when_response_is_null
    stub_request(:post, @transaction_commit_url)
        .with(body:  /.*/ , headers: {'Content-Type' => 'application/json'})
        .to_return(status: 200, body: "{}" )

    error =
        assert_raises KeyError do
          Transbank::Onepay::Transaction.commit(occ: OCC_TO_COMMIT_TRANSACTION_TEST,
                                                external_unique_number: EXTERNAL_UNIQUE_NUMBER_TO_COMMIT_TRANSACTION_TEST)
        end
    assert_equal error.message, "key not found: \"responseCode\""
  end

  def test_transaction_commit_raises_when_response_is_not_ok

    mock_response = JSON.generate({ 'responseCode' => 'INVALID_PARAMS',
                                    'description' => 'Parametros invalidos',
                                    'result' => nil })
    stub_request(:post, @transaction_commit_url)
        .with(body:  /.*/ , headers: {'Content-Type' => 'application/json'})
        .to_return(status: 200, body: mock_response )
    error =
      assert_raises Transbank::Onepay::Errors::TransactionCommitError do
        Transbank::Onepay::Transaction.commit(occ: OCC_TO_COMMIT_TRANSACTION_TEST,
                                              external_unique_number: EXTERNAL_UNIQUE_NUMBER_TO_COMMIT_TRANSACTION_TEST)
      end

    assert_equal error.message, 'INVALID_PARAMS : Parametros invalidos'
  end

  def test_transaction_commit_raises_when_signature_is_not_valid
    mock_response = '{
                      "responseCode": "OK",
                      "description": "OK",
                      "result": {
                          "occ": "1807419329781765",
                          "authorizationCode": "906637",
                          "issuedAt": 1530822491,
                          "signature": "INVALID SIGNATURE",
                          "amount": 2490,
                          "transactionDesc": "Venta Normal: Sin cuotas",
                          "installmentsAmount": 2490,
                          "installmentsNumber": 1,
                          "buyOrder": "20180705161636514"
                      }
                  }'
    stub_request(:post, @transaction_commit_url)
        .with(body:  /.*/ , headers: {'Content-Type' => 'application/json'})
        .to_return(status: 200, body: mock_response )
    error =
        assert_raises Transbank::Onepay::Errors::SignatureError do
          Transbank::Onepay::Transaction.commit(occ: OCC_TO_COMMIT_TRANSACTION_TEST,
                                                external_unique_number: EXTERNAL_UNIQUE_NUMBER_TO_COMMIT_TRANSACTION_TEST)
        end
    assert_equal error.message, "The response's signature is not valid."
  end

  def test_transaction_fails_when_channel_is_mobile_and_callback_url_nil
    original_callback_url = Transbank::Onepay::Base.callback_url
    Transbank::Onepay::Base.callback_url = nil
    cart = Transbank::Onepay::Mocks::ShoppingCartMocks[0]

    error =
      assert_raises Transbank::Onepay::Errors::TransactionCreateError do
        Transbank::Onepay::Transaction.create(shopping_cart: cart, channel: Transbank::Onepay::Channel::MOBILE)
      end
    assert_equal error.message, "You need to set a valid callback if you want to use the MOBILE channel"
    Transbank::Onepay::Base.callback_url = original_callback_url
  end

  def test_transaction_succeeds_when_channel_is_mobile_and_callback_url_is_not_null
    WebMock.allow_net_connect!
    original_callback_url = Transbank::Onepay::Base.callback_url
    Transbank::Onepay::Base.callback_url = "http://some.callback.url"

    cart = Transbank::Onepay::Mocks::ShoppingCartMocks[0]

    response = Transbank::Onepay::Transaction.create(shopping_cart: cart)
    assert_equal response.response_code, "OK"
    assert_equal response.description, "OK"
    refute_nil response.qr_code_as_base64
    Transbank::Onepay::Base.callback_url = original_callback_url
  end

  def test_transaction_fails_when_channel_is_app_and_app_scheme_is_null
    original_app_scheme = Transbank::Onepay::Base.app_scheme
    Transbank::Onepay::Base.app_scheme = nil
    cart = Transbank::Onepay::Mocks::ShoppingCartMocks[0]

    error =
      assert_raises Transbank::Onepay::Errors::TransactionCreateError do
        Transbank::Onepay::Transaction.create(shopping_cart: cart, channel: Transbank::Onepay::Channel::APP)
      end

    assert_equal error.message, "You need to set an app_scheme if you want to use the APP channel"
    Transbank::Onepay::Base.app_scheme = original_app_scheme
  end

  def test_transaction_fails_when_channel_is_app_and_app_scheme_is_not_null
    WebMock.allow_net_connect!
    original_app_scheme = Transbank::Onepay::Base.app_scheme
    Transbank::Onepay::Base.app_scheme = 'somescheme'
    cart = Transbank::Onepay::Mocks::ShoppingCartMocks[0]

    response = Transbank::Onepay::Transaction.create(shopping_cart: cart, channel: Transbank::Onepay::Channel::APP)
    assert_equal response.response_code, "OK"
    assert_equal response.description, "OK"
    refute_nil response.qr_code_as_base64

    Transbank::Onepay::Base.app_scheme = original_app_scheme
  end

  def test_transaction_create_succeeds_when_external_unique_number_is_null
    WebMock.allow_net_connect!
    original_app_scheme = Transbank::Onepay::Base.app_scheme
    Transbank::Onepay::Base.app_scheme = 'somescheme'
    cart = Transbank::Onepay::Mocks::ShoppingCartMocks[0]

    response = Transbank::Onepay::Transaction.create(shopping_cart: cart, channel: Transbank::Onepay::Channel::APP, external_unique_number: nil)
    assert_equal response.response_code, "OK"
    assert_equal response.description, "OK"
    refute_nil response.qr_code_as_base64

    Transbank::Onepay::Base.app_scheme = original_app_scheme
  end

  def test_transaction_create_succeds_when_external_unique_number_is_present
    WebMock.allow_net_connect!
    original_app_scheme = Transbank::Onepay::Base.app_scheme
    Transbank::Onepay::Base.app_scheme = 'somescheme'
    cart = Transbank::Onepay::Mocks::ShoppingCartMocks[0]

    response = Transbank::Onepay::Transaction.create(shopping_cart: cart, channel: Transbank::Onepay::Channel::APP,external_unique_number: "1234abc")
    assert_equal response.response_code, "OK"
    assert_equal response.description, "OK"
    refute_nil response.qr_code_as_base64

    Transbank::Onepay::Base.app_scheme = original_app_scheme
  end

  def test_transaction_create_request_succeeds_when_commerce_logo_url_is_present
    WebMock.allow_net_connect!
    Transbank::Onepay::Base.app_scheme = 'somescheme'
    cart = Transbank::Onepay::Mocks::ShoppingCartMocks[0]
    response = Transbank::Onepay::Transaction.create(
      shopping_cart: cart,
      channel: Transbank::Onepay::Channel::WEB,
      external_unique_number: '1234abc',
      options: {
        commerce_logo_url: 'https://via.placeholder.com/150'
      }
    )
    assert_equal response.response_code, 'OK'
    refute_nil response.qr_code_as_base64
  end

  def test_transaction_create_request_succeeds_when_width_height_is_present
    WebMock.allow_net_connect!
    Transbank::Onepay::Base.app_scheme = 'somescheme'
    cart = Transbank::Onepay::Mocks::ShoppingCartMocks[0]
    response = Transbank::Onepay::Transaction.create(
      shopping_cart: cart,
      channel: Transbank::Onepay::Channel::WEB,
      external_unique_number: '1234abc',
      options: {
        width_height: 250
      }
    )
    assert_equal response.response_code, 'OK'
    refute_nil response.qr_code_as_base64
  end
end
