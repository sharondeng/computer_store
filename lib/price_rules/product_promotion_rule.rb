require_relative 'base_rule'

# e.g. if you buy 3 Apple TVs, you will pay the price of 2 only
class ProductPromotionRule < BaseRule

  def apply_discount(order)
    # return value to be substracted from total
    (order[sku]/min_items) * (original_price - discount_price)
  end
end