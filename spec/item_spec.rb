require_relative '../lib/item'

describe Item do
  subject(:item) { described_class.new(sku: 'ipd', name: 'Super iPad',  price: 549.99) }

  describe '#price' do
    it 'should return the price of the item' do
      expect(item.price).to eq 549.99
    end
  end

  describe '#sku' do
    it 'should return the sku of the item' do
      expect(item.sku).to eq 'ipd'
    end
  end
end