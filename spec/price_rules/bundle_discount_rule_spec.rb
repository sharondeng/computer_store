require_relative '../../lib/price_rules/bundle_discount_rule'

describe BundleDiscountRule do
  subject(:item_discount) { described_class.new(sku: 'vga', min_items: 1, pairing_sku: 'mbp',
                                                discount_price: 0, original_price: 30.00) }

  describe '#apply' do
    it 'should not apply discount price due to number of items less than min items' do
      expect(item_discount.apply({ 'vga' => 0,  'mbp' => 1})).to eq 0
    end

    it 'should apply discount price only on one vga' do
      expect(item_discount.apply({ 'vga' => 2,  'mbp' => 1 })).to eq item_discount.original_price - item_discount.discount_price
    end

    it 'should apply discount price only on two vga' do
      expect(item_discount.apply({ 'vga' => 2,  'mbp' => 3 })).to eq (item_discount.original_price - item_discount.discount_price) * 2
    end
  end
end
