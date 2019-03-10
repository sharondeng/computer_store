require_relative 'base_rule'

module PriceRules

  # e.g. we will bundle in a free VGA adapter free of charge with every MacBook Pro sold
  class BundleDiscountRule < BaseRule

    attr_reader :pairing_sku

    def initialize(options)
      @pairing_sku = options[:pairing_sku]
      super
    end

    def should_get_discount?(order)
      order[sku] >= min_items && order[pairing_sku] >= min_items
    end

    def apply_discount(order)
      delta_price = original_price - discount_price
      if order[pairing_sku] >= order[sku]
        delta_price * order[sku]
      else
        delta_price * order[pairing_sku]
      end
    end
  end
end