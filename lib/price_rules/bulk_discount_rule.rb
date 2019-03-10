require_relative 'base_rule'

# e.g. the brand new Super iPad will have a bulk discounted applied,
# where the price will drop to $499.99 each, if someone buys more than 4
class BulkDiscountRule < BaseRule
  def apply_discount(order)
    # return value to be substracted from total
    (original_price - discount_price) * order[sku]
  end
end