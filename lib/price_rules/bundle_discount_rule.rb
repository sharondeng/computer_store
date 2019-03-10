require_relative 'base_rule'

# e.g. the brand new Super iPad will have a bulk discounted applied,
# where the price will drop to $499.99 each, if someone buys more than 4
class BundleDiscountRule < BaseRule

  attr_reader :discount_price

  def initialize(options)
    @discount_price = options[:discount_price]
    super
  end

  def apply_discount(order)
    # return value to be substracted from total
    (original_price - discount_price) * order[sku]
  end
end