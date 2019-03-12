require_relative '../../lib/price_rules/bundle_discount_rule'

describe PriceRules::BundleDiscountRule do
  let(:original_price) { 30.00 }

  subject(:item_discount) { described_class.new(sku: 'vga', min_items: 1, pairing_sku: 'mbp',
                                                discount_price: 0) }

  describe '#apply' do
    it 'should not apply discount price due to number of items less than min items' do
      expect(item_discount.apply({ 'vga' => 0,  'mbp' => 1}, {'vga' => original_price })).to eq 0
    end

    it 'should apply discount price only on one vga' do
      expect(item_discount.apply({ 'vga' => 2,  'mbp' => 1 }, {'vga' => original_price })).to eq original_price - item_discount.discount_price
    end

    it 'should apply discount price only on two vga' do
      expect(item_discount.apply({ 'vga' => 2,  'mbp' => 3 }, {'vga' => original_price })).to eq (original_price - item_discount.discount_price) * 2
    end
  end
end
