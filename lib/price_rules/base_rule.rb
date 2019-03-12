module PriceRules
  class BaseRule

    # Raised when abstract method is not implement in derived class
    class NotImplementedError < StandardError; end

    attr_reader :sku, :min_items, :discount_price

    def initialize(options)
      @sku = options[:sku]
      @min_items = options[:min_items]
      @discount_price = options[:discount_price]
    end

    def apply(order, price_list)
      should_get_discount?(order) ? apply_discount(order, price_list[sku]) : 0
    end


    def should_get_discount?(order)
      order[sku] >= min_items
    end

    def apply_discount(order, original_price)
      # return value to be substracted from total
      raise NotImplementedError, 'Abstract method must be implemented in derived class'
    end
  end
end
