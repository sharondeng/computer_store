class BaseRule

  attr_reader :sku, :min_items, :original_price

  def initialize(options)
    @sku = options[:sku]
    @min_items = options[:min_items]
    @original_price = options[:original_price]
  end

  def apply(order)
    should_get_discount?(order) ? apply_discount(order) : 0
  end


  def should_get_discount?(order)
    order[sku] >= min_items
  end

  def apply_discount(order)
    puts '---- to be defined in derived class'
    # return value to be substracted from total
  end
end
