require 'test_helper'
require 'webmock/minitest'

class MallBinInfoTest < Transbank::WebPayPlus::Test 
  def setup
    @query_bin_url = "https://webpay3gint.transbank.cl/rswebpaytransaction/api/oneclick/v1.2/bin_info"
    @tbk_user_valid = "tbk_user_123"
    @tbk_user_invalid = "A" * (Transbank::Common::ApiConstants::TBK_USER_LENGTH + 1)


    @mock_response = {
      bin_issuer: "TEST COMMERCE BANK",
      bin_payment_type: "Credito",
      bin_brand: "Visa"
    }.to_json

    stub_request(:post, @query_bin_url)
      .with(body: { tbk_user: @tbk_user_valid }.to_json, headers: { 'Content-Type' => 'application/json' })
      .to_return(status: 200, body: @mock_response)

    WebMock.disable_net_connect!
  end

  def test_query_bin_success
    transaction = Transbank::Webpay::Oneclick::MallBinInfo.build_for_integration(
      Transbank::Common::IntegrationCommerceCodes::ONECLICK_MALL,
      Transbank::Common::IntegrationApiKeys::WEBPAY
    )
    response = transaction.query_bin(@tbk_user_valid)
    assert_equal "Visa", response["bin_brand"]
    assert_equal "Credito", response["bin_payment_type"]
  end

  def test_query_bin_raises_error_when_tbk_user_is_too_long
    transaction = Transbank::Webpay::Oneclick::MallBinInfo.build_for_integration(
      Transbank::Common::IntegrationCommerceCodes::ONECLICK_MALL,
      Transbank::Common::IntegrationApiKeys::WEBPAY
    )

    error = assert_raises Transbank::Shared::TransbankError do
      transaction.query_bin(@tbk_user_invalid)
    end

    expected_message = "tbk_user is too long, the maximum length is #{Transbank::Common::ApiConstants::TBK_USER_LENGTH}"
    assert_equal expected_message, error.message
  end
end
