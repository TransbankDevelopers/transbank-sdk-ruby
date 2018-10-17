require 'transbank/sdk/onepay/models/shopping_cart'
require 'transbank/sdk/onepay/models/item'
require 'transbank/sdk_test'
require 'transbank/sdk/onepay/errors/shopping_cart_error'

class ShoppingCartTest < Transbank::Onepay::Test

  def setup
    @cart_items = [{"amount": 100, "quantity": 10, "description": "something"},
                   {"amount": 200, "quantity": 20, "description": "something else"},
                   {"amount": 300, "quantity": 30, "description": "third element"}]
  end

  def test_shopping_cart_creation_raises_if_not_array
    string = "not json"
    error =
      assert_raises NoMethodError do
        Transbank::Onepay::ShoppingCart.new string
      end
    assert_equal error.message, "undefined method `each' for \"not json\":String"
  end

  def test_successfully_creates_a_shopping_cart_from_an_array_of_items

    cart = Transbank::Onepay::ShoppingCart.new @cart_items
    assert cart.is_a? Transbank::Onepay::ShoppingCart
    assert_equal cart.items_quantity, 60
    assert_equal cart.total, 14000
    item1 = Transbank::Onepay::Item.new({"amount": 100, "quantity": 10, "description": "something"})

    assert_equal cart.items.first.description, item1.description
    assert_equal cart.items.first.quantity, item1.quantity
    assert_equal cart.items.first.amount, item1.amount
    assert_equal cart.items.first.expire, item1.expire
    assert_equal cart.items.first.additional_data, item1.additional_data
    
    item2 = Transbank::Onepay::Item.new({"amount": 200, "quantity": 20, "description": "something else"})
    assert_equal cart.items[1].description, item2.description
    assert_equal cart.items[1].quantity, item2.quantity
    assert_equal cart.items[1].amount, item2.amount
    assert_equal cart.items[1].expire, item2.expire
    assert_equal cart.items[1].additional_data, item2.additional_data

    item3 = Transbank::Onepay::Item.new({"amount": 300, "quantity": 30, "description": "third element"})
    assert_equal cart.items[2].description, item3.description
    assert_equal cart.items[2].quantity, item3.quantity
    assert_equal cart.items[2].amount, item3.amount
    assert_equal cart.items[2].expire, item3.expire
    assert_equal cart.items[2].additional_data, item3.additional_data
  end

  def test_can_add_items_to_cart
    cart = Transbank::Onepay::ShoppingCart.new
    assert cart.items.empty?
    item1 = Transbank::Onepay::Item.new({"amount": 100, "quantity": 10, "description": "something"})

    assert cart.items.empty?

    cart << item1
    assert cart.items.first == item1
    assert_equal cart.items.size, 1
    assert_equal cart.total, (100 * 10)

    item2 = Transbank::Onepay::Item.new({"amount": 200, "quantity": 20, "description": "something else"})

    cart.add item2
    assert cart.items[1], item2
    assert_equal cart.items.size, 2
    assert_equal cart.total, (100 * 10 + 200 * 20)
  end

  def test_can_remove_items_from_a_cart
    cart = Transbank::Onepay::ShoppingCart.new @cart_items
    assert cart.is_a? Transbank::Onepay::ShoppingCart
    assert_equal cart.items_quantity, 60
    assert_equal cart.total, 14000
    assert_equal cart.items.size, 3

    item1 = Transbank::Onepay::Item.new({"amount": 100, "quantity": 10, "description": "something"})
    item2 = Transbank::Onepay::Item.new({"amount": 200, "quantity": 20, "description": "something else"})
    item3 = Transbank::Onepay::Item.new({"amount": 300, "quantity": 30, "description": "third element"})

    cart.remove item1
    assert_equal cart.items.size, 2
    assert_equal cart.total, (200 * 20) + (300 * 30)

    assert_equal cart.items.first, item2
    assert_equal cart.items[1], item3

    cart.remove item3
    assert_equal cart.items.size, 1
    assert_equal cart.total, (200 * 20)

    cart.remove item2
    assert cart.items.empty?
    assert_equal cart.total, 0
  end

  def test_can_remove_all_items_from_a_cart
    cart = Transbank::Onepay::ShoppingCart.new @cart_items
    assert cart.is_a? Transbank::Onepay::ShoppingCart
    assert_equal cart.items_quantity, 60
    assert_equal cart.total, 14000
    assert_equal cart.items.size, 3

    cart.remove_all
    assert cart.items.empty?
    assert_equal cart.items_quantity, 0
    assert_equal cart.total, 0
    assert_equal cart.items.size, 0
  end

  def test_shopping_cart_raises_when_removing_an_item_that_doesnt_exist
    cart = Transbank::Onepay::ShoppingCart.new @cart_items

    first_item = cart.items.first
    cart.remove first_item
    assert_equal cart.items.size, 2
    error =
      assert_raises Transbank::Onepay::Errors::ShoppingCartError do
        cart.remove first_item
      end

    assert_equal error.message, 'Item not found'
  end

  def test_shopping_cart_can_add_and_remove_the_same_item_multiple_times
    cart = Transbank::Onepay::ShoppingCart.new @cart_items
    first_item = cart.items.first

    first_item_total = first_item.total
    first_item_quantity = first_item.quantity
    cart_total = cart.total
    cart_items_quantity = cart.items_quantity

    # This is the total amount, when the cart has just been created with these
    # {"amount": 100, "quantity": 10, "description": "something"},
    # {"amount": 200, "quantity": 20, "description": "something else"},
    # {"amount": 300, "quantity": 30, "description": "third element"}
    assert_equal cart_total, 14000
    assert_equal cart_items_quantity, (10 + 20 + 30)

    cart << first_item
    cart_total += first_item_total
    cart_items_quantity += first_item_quantity
    assert_equal cart.items.size, 4
    assert_equal cart.total, cart_total
    assert_equal cart.items_quantity, cart_items_quantity

    cart << first_item
    cart_total += first_item_total
    cart_items_quantity += first_item_quantity
    assert_equal cart.items.size, 5
    assert_equal cart.total, cart_total
    assert_equal cart.items_quantity, cart_items_quantity

    cart.remove first_item
    cart_total -= first_item_total
    cart_items_quantity -= first_item_quantity
    assert_equal cart.items.size, 4
    assert_equal cart.total, cart_total
    assert_equal cart.items_quantity, cart_items_quantity

    cart.remove first_item
    cart_total -= first_item_total
    cart_items_quantity -= first_item_quantity
    assert_equal cart.items.size, 3
    assert_equal cart.total, cart_total
    assert_equal cart.items_quantity, cart_items_quantity

    cart.remove first_item
    cart_total -= first_item_total
    cart_items_quantity -= first_item_quantity
    assert_equal cart.items.size, 2
    assert_equal cart.total, cart_total
    assert_equal cart.items_quantity, cart_items_quantity

    error =
      assert_raises Transbank::Onepay::Errors::ShoppingCartError do
        cart.remove first_item
      end
    assert_equal error.message, 'Item not found'
  end

  def test_total_should_be_updated_if_an_item_is_modified
    cart = Transbank::Onepay::ShoppingCart.new @cart_items
    first_item = cart.items.first

    assert_equal first_item.quantity, 10
    assert_equal first_item.amount, 100
    original_total = 14000
    assert_equal original_total, 14000
    first_item.amount = 200

    # 200 * 10  + 200 * 20 + 300 * 30
    new_total = 15000
    assert_equal new_total, 15000
  end

  def items_quantity_should_be_updated_if_an_item_is_modified
    cart = Transbank::Onepay::ShoppingCart.new @cart_items
    first_item = cart.items.first

    assert_equal first_item.quantity, 10
    assert_equal first_item.amount, 100

    original_quantity = cart.items_quantity
    assert_equal original_quantity, 60
    first_item.quantity = 100

    assert_equal cart.items, 150
  end
end