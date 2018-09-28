require 'request'
require '../../../../lib/transbank/sdk/channels'
class TransactionCreateRequest
  include Request

  attr_accessor :external_unique_number
  attr_accessor :total
  attr_accessor :items_quantity
  attr_accessor :issued_at
  attr_accessor :items
  attr_accessor :callback_url
  attr_accessor :channel
  attr_accessor :app_scheme
  attr_accessor :signature

  def initialize(external_unique_number, total, items_quantity, issued_at, items,
                 callback_url = nil, channel = Channel::WEB, app_scheme = nil)

    @external_unique_number = validate_external_unique_number(external_unique_number)
    @total = validate_total(total)
    @items_quantity = validate_items_quantity(items_quantity)
    @items = validate_items(items)
    @issued_at = issued_at
    @callback_url = validate_callback_url(callback_url)
    @channel = validate_channel(channel)
    @app_scheme = app_scheme || ''
    @signature = nil
  end

  def validate_external_unique_number(external_unique_number)
    raise StandardError('External Unique Number cannot be null.') if external_unique_number.nil?
    external_unique_number
  end

  def validate_total(total)
    raise StandardError('Total cannot be null.') if total.nil?
    raise StandardError('Total cannot be less than zero.') if total < 0
    total
  end

  def validate_items_quantity(items_quantity)
    raise StandardError('Items quantity cannot be null.') if items_quantity.nil?
    raise StandardError('Items quantity cannot be less than zero.') if items_quantity < 0
    items_quantity
  end

  def validate_items(items)
    raise StandardError('Items must be an array.') unless items.is_a? Array
    raise StandardError('Items must not be empty.') if items.empty?
    items
  end

  def validate_callback_url(callback_url)
    raise StandardError('Callback url cannot be null.') if callback_url.nil?
    callback_url
  end

  def validate_channel(channel)
    raise StandardError('Channel cannot be null.') if channel.nil?
    channel
  end
end