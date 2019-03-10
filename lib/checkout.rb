require 'catalogue'
require 'product'
require 'money'

class Checkout

  attr_reader :products, :pricing_rules, :order, :price_list

  def initialize(products = Catalogue::PRODUCTS, pricing_rules = nil)
    @products = products.map{|p| Product.new(p)}
    @price_list = @products.map{|p|[p.sku, p.price]}.to_h
    @pricing_rules = pricing_rules
    @order = Hash.new(0)
  end

  def scan(item_code)
    fail "#{item_code} is not a valid item code" unless item_in_products?(item_code)
    @order[item_code] += 1
  end

  def total
    to_currency(total_cost)
  end

  private

  def item_in_products?(item_code)
    products.map{ |product| product.sku }
        .include?(item_code)
  end

  def sum_without_discounts(order)
    order.reduce(0) do |sum, (item, num)|
      sum += cost_for(item, num)
    end
  end

  def apply_discounts(cost_before_discounts, order)
    return cost_before_discounts unless pricing_rules
    pricing_rules.reduce(cost_before_discounts) do |current_total, rule|
      current_total - rule.apply(order)
    end
  end

  def cost_for(item, num)
    price_list[item] * num
  end

  def total_cost
    apply_discounts(sum_without_discounts(order), order)
  end

  def to_currency(cost)
    Money.locale_backend = nil
    Money.new(cost * 100, "AUD").format
  end
end