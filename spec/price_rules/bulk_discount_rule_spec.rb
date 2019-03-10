require_relative '../../lib/price_rules/bulk_discount_rule'

describe BulkDiscountRule do
  subject(:item_discount) { described_class.new(sku: 'ipod', min_items: 3, discount_price: 450.00, original_price: 499.99) }

  describe '#apply' do
    it 'should not apply discount price due to number of items less than min items' do
      expect(item_discount.apply({ 'ipod' => 2 })).to eq 0
    end

    it 'should apply discount price because it reaches the min items' do
      expect(item_discount.apply({ 'ipod' => 3 })).to eq (item_discount.original_price - item_discount.discount_price) * 3
    end

  end
end
