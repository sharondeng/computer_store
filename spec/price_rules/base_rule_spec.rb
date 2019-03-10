require_relative '../../lib/price_rules/base_rule'

describe PriceRules::BaseRule do
  subject(:item_discount) { described_class.new(sku: 'ipod', min_items: 3, discount_price: 450.00, original_price: 499.99) }

  describe '#apply_discount' do
    it 'should raise an error as it is an abstract method' do
      expect{item_discount.apply_discount({ 'ipod' => 3 }) }.to raise_error 'Abstract method must be implemented in derived class'
    end
  end
end
