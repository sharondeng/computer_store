require_relative '../lib/checkout'
require_relative '../lib/price_rules/product_promotion_rule'
require_relative '../lib/price_rules/bundle_discount_rule'

describe Checkout do
  let(:item_1) { {sku: 'ipd', name: 'Super iPad',  price: 549.99} }
  let(:item_2) { {sku: 'atv', name: 'Apple TV', price: 109.50} }
  let(:products) { [item_1, item_2] }
  subject(:checkout) { described_class.new(products)}

  describe '#scan' do
    it 'is expected to raise an error if given a code that is not in products' do
      expect{ checkout.scan('abc') }.to raise_error 'abc is not a valid item code'
    end
  end

  describe '#total' do
    it 'is expected to return the cost without discount' do
      checkout.scan('ipd')
      checkout.scan('ipd')
      checkout.scan('atv')

      expect(checkout.send(:total_cost)).to eq item_1[:price]*2 + item_2[:price]
      expect(checkout.total).to eq '$1209.48'
    end

    describe "#product promotion" do
      let(:products) { [{sku: 'atv', name: 'Apple TV', price: 109.50 }] }
      let(:tv_promotion) {[ProductPromotionRule.new({sku: 'atv', min_items: 3,
                                                     discount_price: 0,
                                                     original_price: products.first[:price]})]}
      subject(:checkout) { described_class.new(products, tv_promotion)}

      it 'is expected to return the cost without discount' do
        checkout.scan('atv')
        checkout.scan('atv')

        expect(checkout.send(:total_cost)).to eq products.first[:price]*2
        expect(checkout.total).to eq '$219.00'
      end

      it 'is expected to apply discount price: buy 3 with price of 2' do
        checkout.scan('atv')
        checkout.scan('atv')
        checkout.scan('atv')

        expect(checkout.send(:total_cost)).to eq products.first[:price]*2
        expect(checkout.total).to eq '$219.00'
      end
    end

    describe "#bundle discount" do
      let(:products) { [{sku: 'ipd', name: 'Super iPad',  price: 549.99}] }
      let(:discount_price) {499.99}
      let(:ipad_promotion) {BundleDiscountRule.new({sku: 'ipd', min_items: 5,
                                                    discount_price: discount_price,
                                                    original_price: products.first[:price]})}
      let(:price_rules) {[ipad_promotion]}
      subject(:checkout) { described_class.new(products, price_rules)}

      it 'is expected to return the cost without discount' do
        checkout.scan('ipd')
        checkout.scan('ipd')
        checkout.scan('ipd')
        checkout.scan('ipd')

        expect(checkout.send(:total_cost)).to eq products.first[:price]*4
        expect(checkout.total).to eq '$2199.96'
      end

      it 'is expected to apply discount price: where the price will drop to $499.99 each, if someone buys more than 4' do
        checkout.scan('ipd')
        checkout.scan('ipd')
        checkout.scan('ipd')
        checkout.scan('ipd')
        checkout.scan('ipd')

        expect(checkout.send(:total_cost)).to eq discount_price*5
        expect(checkout.total).to eq '$2499.95'
      end
    end
  end
end