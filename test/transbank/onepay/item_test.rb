require 'transbank/sdk/onepay/models/item'
require 'transbank/sdk_test'
require 'transbank/sdk/onepay/errors/item_error'

class ItemTest < Transbank::Onepay::Test

  def test_from_json_raises_if_param_is_not_json
    some_string = "a string"
    error =
      assert_raises Transbank::Onepay::Errors::ItemError do
        Transbank::Onepay::Item.from_json some_string
      end
    assert_equal error.message, "json must be a Hash or a String JSON.parse'able to one"
  end

  def test_creates_an_item_from_a_json_string
    json_string = '{"amount": 5000, "quantity": 5, "description": "something valuable"}'

    item = Transbank::Onepay::Item.from_json json_string

    assert item.is_a? Transbank::Onepay::Item
    assert_equal item.amount, 5000
    assert_equal item.quantity, 5
    assert_equal item.description, 'something valuable'

    assert_equal item.expire, 0
    assert_equal item.additional_data, ''
  end

  def test_creates_an_item_from_a_hash
    hash = {"amount": 5000,
            "quantity": 5,
            "description": "something valuable"}
    item = Transbank::Onepay::Item.from_json hash

    assert item.is_a? Transbank::Onepay::Item
    assert_equal item.amount, 5000
    assert_equal item.quantity, 5
    assert_equal item.description, 'something valuable'

    assert_equal item.expire, 0
    assert_equal item.additional_data, ''
  end

  def test_creates_an_item_from_json_with_extra_keys
    json = '{"amount": 2000, "quantity": 2, "description": "something else", "useless key": "irrelevant value will be ignored"}'
    item = Transbank::Onepay::Item.from_json json
    assert item.is_a? Transbank::Onepay::Item
    assert_equal item.amount, 2000
    assert_equal item.quantity, 2
    assert_equal item.description, 'something else'

    assert_equal item.expire, 0
    assert_equal item.additional_data, ''
  end

  def test_creates_an_item_from_json_with_optional_values
    json = '{"amount": 2000, "quantity": 2, "description": "something else", "expire": 123456789, "additionalData": "additional data here"}'
    item = Transbank::Onepay::Item.from_json json
    assert item.is_a? Transbank::Onepay::Item
    assert_equal item.amount, 2000
    assert_equal item.quantity, 2
    assert_equal item.description, 'something else'

    assert_equal item.expire, 123456789
    assert_equal item.additional_data, 'additional data here'
  end

  def test_raises_if_no_description_is_given
    json = '{"amount": 5000, "quantity": 5}'
    error =
      assert_raises Transbank::Onepay::Errors::ItemError do
        Transbank::Onepay::Item.from_json json
      end
    assert_equal error.message, "Description is not a String"
  end

  def test_raises_if_no_description_is_nil
    json = '{"amount": 5000, "quantity": 5, "description": null}'
    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.from_json json
        end
    assert_equal error.message, "Description is not a String"
  end

  def test_raises_if_amount_is_not_given
    json = '{"description": "something pretty", "quantity": 5}'
    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.from_json json
        end
    assert_equal error.message, "Amount must be an Integer"
  end

  def test_raises_if_amount_is_null
    json = '{"description": "something pretty", "quantity": 5, "amount": null}'
    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.from_json json
        end
    assert_equal error.message, "Amount must be an Integer"
  end

  def test_raises_if_amount_is_a_string
    json = '{"amount": "55", "quantity": 5, "description": "something pretty"}'
    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.from_json json
        end
    assert_equal error.message, "Amount must be an Integer"
  end

  def test_raises_if_quantity_is_not_given
    json = '{"description": "something pretty", "amount": 5000}'
    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.from_json json
        end
    assert_equal error.message, "Quantity must be an Integer"
  end

  def test_raises_if_quantity_is_null
    json =  '{"amount": 5000, "quantity": null, "description": "something pretty"}'
    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.from_json json
        end
    assert_equal error.message, "Quantity must be an Integer"
  end


  def test_raises_if_quantity_is_string
    json = '{"amount": 66, "quantity": "5", "description": "something pretty"}'
    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.from_json json
        end
    assert_equal error.message, "Quantity must be an Integer"
  end

  def test_raises_if_amount_is_less_than_zero
    json = '{"amount": -2000, "quantity": 5, "description": "something valuable"}'

    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.from_json json
        end
    assert_equal error.message, "Amount cannot be less than zero"
  end

  def test_raises_if_quantity_is_less_than_zero
    json = '{"amount": 2000, "quantity": -5, "description": "something valuable"}'
    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.from_json json
        end
    assert_equal error.message, "Quantity cannot be less than zero"
  end

  def test_calculates_the_total_amount_to_pay_for_the_item
    json_string = '{"amount": 5000, "quantity": 5, "description": "something valuable"}'

    item = Transbank::Onepay::Item.from_json json_string
    # amount * quantity
    expected_total = 5000 * 5
    assert_equal expected_total, item.total
  end

end