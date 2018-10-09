require 'transbank/sdk/onepay/models/item'
require 'transbank/sdk_test'
require 'transbank/sdk/onepay/errors/item_error'

class ItemTest < Transbank::Onepay::Test

  def test_creating_item_raises_if_param_is_not_hash
    some_string = "a string"
    error =
      assert_raises Transbank::Onepay::Errors::ItemError do
        Transbank::Onepay::Item.new some_string
      end
    assert_equal error.message, "Item must be a Hash"
  end

  def test_creates_an_item_from_a_hash
    hash = {"amount": 5000,
            "quantity": 5,
            "description": "something valuable"}
    item = Transbank::Onepay::Item.new hash

    assert item.is_a? Transbank::Onepay::Item
    assert_equal item.amount, 5000
    assert_equal item.quantity, 5
    assert_equal item.description, 'something valuable'

    assert_equal item.expire, 0
    assert_equal item.additional_data, ''
  end

  def test_creates_an_item_from_a_hash_with_extra_keys
    json = {"amount": 2000, "quantity": 2,
            "description": "something else",
            "useless key": "irrelevant value will be ignored"}
    item = Transbank::Onepay::Item.new json
    assert item.is_a? Transbank::Onepay::Item
    assert_equal item.amount, 2000
    assert_equal item.quantity, 2
    assert_equal item.description, 'something else'

    assert_equal item.expire, 0
    assert_equal item.additional_data, ''
  end

  def test_creates_an_item_from_a_hash_with_optional_values
    json = {"amount": 2000, "quantity": 2, "description": "something else", "expire": 123456789, "additionalData": "additional data here"}
    item = Transbank::Onepay::Item.new json
    assert item.is_a? Transbank::Onepay::Item
    assert_equal item.amount, 2000
    assert_equal item.quantity, 2
    assert_equal item.description, 'something else'

    assert_equal item.expire, 123456789
    assert_equal item.additional_data, 'additional data here'
  end

  def test_raises_if_no_description_is_given
    json = {"amount": 5000, "quantity": 5}
    error =
      assert_raises KeyError do
        Transbank::Onepay::Item.new json
      end
    assert_equal error.message, "key not found: :description"
  end

  def test_raises_if_no_description_is_nil
    json = {"amount": 5000, "quantity": 5, "description": nil}
    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.new json
        end
    assert_equal error.message, "Description cannot be null"
  end

  def test_raises_if_amount_is_not_given
    json = { "description": "something pretty", "quantity": 5 }
    error =
        assert_raises KeyError do
          Transbank::Onepay::Item.new json
        end
    assert_equal error.message, "key not found: :amount"
  end

  def test_raises_if_amount_is_nil
    json = {"description": "something pretty", "quantity": 5, "amount": nil}
    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.new json
        end
    assert_equal error.message, "Amount cannot be null"
  end

  def test_raises_if_amount_is_a_string
    json = {"amount": "55", "quantity": 5, "description": "something pretty"}
    error =
        assert_raises ArgumentError do
          Transbank::Onepay::Item.new json
        end
    assert_equal error.message, "comparison of String with 0 failed"
  end

  def test_raises_if_quantity_is_not_given
    json = {"description": "something pretty", "amount": 5000}
    error =
        assert_raises KeyError do
          Transbank::Onepay::Item.new json
        end
    assert_equal error.message, "key not found: :quantity"
  end

  def test_raises_if_quantity_is_nil
    json = {"amount": 5000, "quantity": nil, "description": "something pretty"}
    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.new json
        end
    assert_equal error.message, "Quantity cannot be null"
  end


  def test_raises_if_quantity_is_string
    json = {"amount": 66, "quantity": "5", "description": "something pretty"}
    error =
        assert_raises ArgumentError do
          Transbank::Onepay::Item.new json
        end
    assert_equal error.message, "comparison of String with 0 failed"
  end

  def test_raises_if_amount_is_less_than_zero
    json = {"amount": -2000, "quantity": 5, "description": "something valuable"}

    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.new json
        end
    assert_equal error.message, "Amount cannot be less than zero"
  end

  def test_raises_if_quantity_is_less_than_zero
    json = {"amount": 2000, "quantity": -5, "description": "something valuable"}
    error =
        assert_raises Transbank::Onepay::Errors::ItemError do
          Transbank::Onepay::Item.new json
        end
    assert_equal error.message, "Quantity cannot be less than zero"
  end

  def test_calculates_the_total_amount_to_pay_for_the_item
    json = {"amount": 5000, "quantity": 5, "description": "something valuable"}

    item = Transbank::Onepay::Item.new json
    # amount * quantity
    expected_total = 5000 * 5
    assert_equal expected_total, item.total
  end

end