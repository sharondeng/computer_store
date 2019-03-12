require 'require_all'
require_all 'lib'

describe Checkout do
  let(:item_1) { {sku: 'ipd', name: 'Super iPad',  price: 549.99} }
  let(:item_2) { {sku: 'atv', name: 'Apple TV', price: 109.50} }
  let(:products) { [item_1, item_2] }
  subject(:checkout) { described_class.new(products: products)}

  describe '#scan' do
    it 'should raise an error if an item is not in product catalogue' do
      expect{ checkout.scan('abc') }.to raise_error 'abc is not a valid item code'
    end
  end

  describe '#total' do
    it 'should return 0 if there is no item scanned' do
      expect(checkout.send(:total_cost)).to eq 0
      expect(checkout.total).to eq '$0.00'
    end

    it 'should return the cost without discount' do
      checkout.scan('ipd')
      checkout.scan('ipd')
      checkout.scan('atv')

      expect(checkout.send(:total_cost)).to eq item_1[:price]*2 + item_2[:price]
      expect(checkout.total).to eq '$1209.48'
    end

    describe "#product promotion" do
      let(:products) { [{sku: 'atv', name: 'Apple TV', price: 109.50 }] }
      let(:tv_promotion) {[PriceRules::ProductPromotionRule.new({sku: 'atv', min_items: 3,
                                                     discount_price: 0})]}
      subject(:checkout) { described_class.new(products: products, pricing_rules: tv_promotion)}

      it 'should return the cost without discount' do
        checkout.scan('atv')
        checkout.scan('atv')

        expect(checkout.send(:total_cost)).to eq products.first[:price]*2
        expect(checkout.total).to eq '$219.00'
      end

      it 'should apply discount price: buy 3 with price of 2' do
        checkout.scan('atv')
        checkout.scan('atv')
        checkout.scan('atv')

        expect(checkout.send(:total_cost)).to eq products.first[:price]*2
        expect(checkout.total).to eq '$219.00'
      end
    end

    describe "#bulk discount" do
      let(:products) { [{sku: 'ipd', name: 'Super iPad',  price: 549.99}] }
      let(:discount_price) {499.99}
      let(:ipad_promotion) {PriceRules::BulkDiscountRule.new({sku: 'ipd', min_items: 5,
                                                  discount_price: discount_price})}
      let(:price_rules) {[ipad_promotion]}
      subject(:checkout) { described_class.new(products: products, pricing_rules: price_rules)}

      it 'should return the cost without discount' do
        checkout.scan('ipd')
        checkout.scan('ipd')
        checkout.scan('ipd')
        checkout.scan('ipd')

        expect(checkout.send(:total_cost)).to eq products.first[:price]*4
        expect(checkout.total).to eq '$2199.96'
      end

      it 'should apply discount price: where the price will drop to $499.99 each, if someone buys more than 4' do
        checkout.scan('ipd')
        checkout.scan('ipd')
        checkout.scan('ipd')
        checkout.scan('ipd')
        checkout.scan('ipd')

        expect(checkout.send(:total_cost)).to eq discount_price*5
        expect(checkout.total).to eq '$2499.95'
      end
    end

    describe "#bundle discount" do
      let(:products) { [{sku: 'vga', name: 'VGA adapter',  price: 30.00},
                        {sku: 'mbp', name: 'MacBook Pro',  price: 1399.99}] }
      let(:free_vga) {PriceRules::BundleDiscountRule.new({sku: 'vga', min_items: 1,
                                                  discount_price: 0,
                                                  pairing_sku: 'mbp'})}
      let(:price_rules) {[free_vga]}
      subject(:checkout) { described_class.new(products: products, pricing_rules: price_rules)}

      it 'should return the cost without discount' do
        checkout.scan('vga')
        checkout.scan('vga')

        expect(checkout.send(:total_cost)).to eq products.first[:price]*2
        expect(checkout.total).to eq '$60.00'
      end

      it 'should apply discount price: a free VGA adapter free with every MacBook Pro sold' do
        checkout.scan('vga')
        checkout.scan('mbp')

        expect(checkout.send(:total_cost)).to eq products.last[:price]
        expect(checkout.total).to eq '$1399.99'
      end

      it 'should apply discount price on one vga' do
        checkout.scan('vga')
        checkout.scan('vga')
        checkout.scan('mbp')

        expect(checkout.send(:total_cost)).to eq products.map{|p| p[:price]}.inject(:+)
        expect(checkout.total).to eq '$1429.99'
      end
    end
  end
end