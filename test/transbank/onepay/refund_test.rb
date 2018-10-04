require 'transbank/sdk/onepay/base'
require 'transbank/sdk_test'
require 'transbank/sdk/onepay/models/refund'
require 'transbank/onepay/mocks/shopping_cart_mocks'
require 'transbank/sdk/onepay/models/options'
require 'json'
require 'transbank/sdk/onepay/errors/refund_create_error'

class RefundTest < Transbank::Onepay::Test

  def setup
    Transbank::Onepay::Base.shared_secret = "P4DCPS55QB2QLT56SQH6#W#LV76IAPYX"
    Transbank::Onepay::Base.api_key = "mUc0GxYGor6X8u-_oB3e-HWJulRG01WoC96-_tUA3Bg"
    Transbank::Onepay::Base.integration_type = "MOCK"
    # These are hardcoded values that we know are valid
    # for testing purposes
    @external_unique_number = "1532376544050"
    @occ = "1807829988419927"
    # This invalid OCC value MUST be 'INVALID OCC', since our MOCK server
    # returns an invalid transaction only when occ == 'INVALID OCC'
    @invalid_occ = "INVALID OCC"
    @authorization_code = "497490"
    @refund_amount = 27500
    # Force the use of stubs unless necessary
    WebMock.disable_net_connect!
  end

  def test_refund_with_options_works
    WebMock.allow_net_connect!
    api_key = Transbank::Onepay::Base.api_key
    shared_secret = Transbank::Onepay::Base.shared_secret
    options = {api_key: api_key, shared_secret: shared_secret}
    response = Transbank::Onepay::Refund.create(@refund_amount,
                                                @occ,
                                                @external_unique_number,
                                                @authorization_code,
                                                options)
    assert_equal response.response_code, 'OK'
    assert_equal response.description, 'OK'
  end

  def test_refund_without_options_works
    WebMock.allow_net_connect!
    api_key = Transbank::Onepay::Base.api_key
    shared_secret = Transbank::Onepay::Base.shared_secret
    response = Transbank::Onepay::Refund.create(@refund_amount,
                                                @occ,
                                                @external_unique_number,
                                                @authorization_code)
    assert_equal response.response_code, 'OK'
    assert_equal response.description, 'OK'
  end

  def test_refund_raises_when_invalid
    WebMock.allow_net_connect!
    api_key = Transbank::Onepay::Base.api_key
    shared_secret = Transbank::Onepay::Base.shared_secret
    options = {api_key: api_key, shared_secret: shared_secret }

    error =
      assert_raises Transbank::Onepay::Errors::RefundCreateError do
        Transbank::Onepay::Refund.create(@refund_amount,
                                         @invalid_occ,
                                         '1111',
                                         "f506a955-800c-4185-8818-4ef9fca97aae")
      end
    assert_equal error.message, "INVALID_PARAMS : Parametros invalidos"
  end


end