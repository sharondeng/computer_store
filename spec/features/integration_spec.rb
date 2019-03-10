require 'require_all'
require_all 'lib'

describe 'Integration Specs' do
  let(:products) do
    [
        {sku: 'ipd', name: 'Super iPad',   price: 549.99},
        {sku: 'mbp', name: 'MacBook Pro',  price: 1399.99},
        {sku: 'atv', name: 'Apple TV',     price: 109.50},
        {sku: 'vga', name: 'VGA adapter',  price: 30.00}
    ]
  end

  let(:product_price) { products.map{|p| [p[:sku], p[:price]]}.to_h}

  let(:ipad_discount_price) {499.99}
  let(:tv_promotion) { ProductPromotionRule.new({sku: 'atv', min_items: 3,
                                                 discount_price: 0,
                                                 original_price:  product_price['atv']})}
  let(:ipad_promotion) { BulkDiscountRule.new({sku: 'ipd', min_items: 5,
                                                 discount_price: ipad_discount_price,
                                                 original_price: product_price['ipd']})}
  let(:free_adapter) { BundleDiscountRule.new({sku: 'vga', min_items: 1,
                                               discount_price: 0,
                                               pairing_sku: 'mbp',
                                               original_price: product_price['vga']})}
  let(:pricing_rules) { [tv_promotion, ipad_promotion, free_adapter] }
  subject(:checkout) { Checkout.new(products, pricing_rules) }

  it 'should carry out 3 for 2 deal on Apple TVs' do
    # SKUs Scanned: atv, atv, atv, vga
    # Total expected: $249.00
    checkout.scan 'atv'
    checkout.scan 'atv'
    checkout.scan 'atv'
    checkout.scan 'vga'

    expect(checkout.total).to eq '$249.00'
  end

  it 'should drop ipad to $499.99 each, if someone buys more than 4' do
    # SKUs Scanned: atv, ipd, ipd, atv, ipd, ipd, ipd
    # Total expected: $2718.95
    checkout.scan 'atv'
    checkout.scan 'ipd'
    checkout.scan 'ipd'
    checkout.scan 'atv'
    checkout.scan 'ipd'
    checkout.scan 'ipd'
    checkout.scan 'ipd'

    expect(checkout.total).to eq '$2718.95'
  end

  it 'should bundle in a free VGA adapter free of charge with every MacBook Pro sold' do
    # SKUs Scanned: mbp, vga, ipd
    # Total expected: $1949.98
    checkout.scan 'mbp'
    checkout.scan 'vga'
    checkout.scan 'ipd'

    expect(checkout.total).to eq '$1949.98'
  end

end
