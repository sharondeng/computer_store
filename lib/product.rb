class Product
  attr_reader :sku, :name, :price

  def initialize(options)
    @sku = options[:sku]
    @name = options[:name]
    @price = options[:price]
  end

end
