module Catalogue
  PRODUCTS = [
      { sku: 'ipd', name: 'Super iPad',   price: 549.99 },
      { sku: 'mbp', name: 'MacBook Pro',  price: 1399.99 },
      { sku: 'atv', name: 'Apple TV',     price: 109.50 },
      { sku: 'vga', name: 'VGA adapter',  price: 30.00 },
  ].freeze

  DATA_PATH = File.expand_path('../../config', __FILE__)

  # Loads and returns the catalogue stored in JSON file in the config directory.
  # if fails at loading, return PRODUCTS statically specified
  def load_catalogue
    catalogue_file = parse_catalogue_file("product_catalogue.json")
    catalogue_file ? catalogue_file[:list] : PRODUCTS
  end

  private

  def parse_catalogue_file(filename)
    begin
      json = File.read("#{DATA_PATH}/#{filename}")
      json.force_encoding(::Encoding::UTF_8) if defined?(::Encoding)
      JSON.parse(json, symbolize_names: true)
    rescue => error
      p error.message
      return
    end
  end
end