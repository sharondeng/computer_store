require_relative '../../lib/price_rules/product_promotion_rule'

describe ProductPromotionRule do
  subject(:item_discount) { described_class.new(sku: 'atv', min_items: 3, discount_price: 0, original_price: 109.50) }

  describe '#apply' do
    it 'should not apply discount price due to number of items less than min items' do
      expect(item_discount.apply({ 'atv' => 2 })).to eq 0
    end

    it 'should apply discount price because number of items is 3' do
      expect(item_discount.apply({ 'atv' => 3 })).to eq item_discount.original_price
    end

    it 'should apply discount price twice because number of items is 6' do
      expect(item_discount.apply({ 'atv' => 6 })).to eq item_discount.original_price * 2
    end
  end
end