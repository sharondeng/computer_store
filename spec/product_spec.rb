require_relative '../lib/product'

describe Product do
  subject(:product) { described_class.new(sku: 'ipd', name: 'Super iPad',  price: 549.99) }

  describe '#price' do
    it 'should return the price of the product' do
      expect(product.price).to eq 549.99
    end
  end

  describe '#sku' do
    it 'should return the sku of the product' do
      expect(product.sku).to eq 'ipd'
    end
  end
end