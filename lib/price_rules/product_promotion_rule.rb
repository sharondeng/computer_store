require_relative 'base_rule'

# e.g. if you buy 3 Apple TVs, you will pay the price of 2 only
class ProductPromotionRule < BaseRule

  attr_reader :discount_price

  def initialize(options)
    @discount_price = options[:discount_price]
    super
  end

  def apply_discount(order)
    # return value to be substracted from total
    original_price - discount_price
  end
end