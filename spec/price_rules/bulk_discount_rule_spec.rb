require_relative '../../lib/price_rules/bulk_discount_rule'

describe PriceRules::BulkDiscountRule do
  let(:original_price) { 499.99 }
  subject(:item_discount) { described_class.new(sku: 'ipod', min_items: 3, discount_price: 450.00) }

  describe '#apply' do
    it 'should not apply discount price due to number of items less than min items' do
      expect(item_discount.apply({ 'ipod' => 2 }, {'ipod' => original_price})).to eq 0
    end

    it 'should apply discount price because it reaches the min items' do
      expect(item_discount.apply({ 'ipod' => 3 }, {'ipod' => original_price})).to eq (original_price - item_discount.discount_price) * 3
    end

  end
end
