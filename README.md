# README

A simple ruby app for a computer store to calculate the total cost base on the price list and pricing rules at the checkout.  
This is a simple coding exercise without any database, or rails (MVC) framework.

## Installation Instructions

It is required to install ruby (ver >= 2.3) for running the app. After ruby installation, a few ruby gem files can be installed by 
```
cd computer_store
$ bundle install
```

## Product catalogue

The sample catalogue is specified in config/product_catalogue.json and it can be modified for any purposes.

## Running Tests

To run the test suite, simply run rspec from the root directory. The test result will be shown on the console screen while running.

```
$ rspec
```

## Usage Instructions

The app can be run from irb. To open irb by type `$ irb` in the project root directory.

```ruby
$ irb

# You will need to import files from lib,
# This will import all the classes required to run the system

require 'require_all'
require_all 'lib'

# since there is product catalogue already built in, you can run the checkout app without creating your own. 
# To build your catalog, you can either modify config/product_catalogue.json 
# or create product hash for each product in the catalog as following:
p_ipd = { sku: 'ipd', name: 'Super iPad',   price: 549.99 }
p_mbp = { sku: 'mbp', name: 'MacBook Pro',  price: 1399.99 }
p_atv = { sku: 'atv', name: 'Apple TV',     price: 109.50 }
p_vga = { sku: 'vga', name: 'VGA adapter',  price: 30.00 }

# Assign these items to an array to be passed on to the checkout
products = [p_ipd, p_mbp, p_atv, p_vga]

# You will then need to build any pricing rules to be applied,
# Currently, three rules are available: ProductPromotionRule, BulkDiscountRule, and BundleDiscountRule
# you can create rules as following:
#  ProductPromotionRule: if a customer buy 3 Apple TVs, the price will be of 2 only
tv_promotion = PriceRules::ProductPromotionRule.new({sku: 'atv', min_items: 3, discount_price: 0})

#  BulkDiscountRule: the price will drop to $499.99 each, if a customer buys more than 4
ipad_promotion = PriceRules::BulkDiscountRule.new({sku: 'ipd', min_items: 5, discount_price: 499.99})

#  BundleDiscountRule: a free VGA adapter will be included, if a customer buys a MacBook Pro
free_adapter = PriceRules::BundleDiscountRule.new({sku: 'vga', min_items: 1, discount_price: 0, pairing_sku: 'mbp'})

# You can build pricing rules array to be passed on to the checkout
pricing_rules = [tv_promotion, ipad_promotion, free_adapter]


# To instantiate the Checkout with the pricing_rules and products defined early on
checkout = Checkout.new(products: products, pricing_rules: pricing_rules)

# Or to instantiate the Checkout with the pricing_rules in conjunction with built-it catalogue
checkout = Checkout.new(pricing_rules: pricing_rules)

# Checkout has two methods,
# #scan => this takes the key (sku) code of the item 
# #total => this returns the total cost

# Example 1:  3 for 2 deal on Apple TVs
# SKUs Scanned: atv, atv, atv, vga
# Total expected: $249.00
checkout = Checkout.new(products: products, pricing_rules: pricing_rules)
checkout.scan 'atv'
checkout.scan 'atv'
checkout.scan 'atv'
checkout.scan 'vga'

checkout.total
=> '$249.00'

# Example 2:  the price will drop to $499.99 each, if a customer buys more than 4
# SKUs Scanned: atv, ipd, ipd, atv, ipd, ipd, ipd
# Total expected: $2718.95
checkout = Checkout.new(products: products, pricing_rules: pricing_rules)
checkout.scan 'atv'
checkout.scan 'ipd'
checkout.scan 'ipd'
checkout.scan 'atv'
checkout.scan 'ipd'
checkout.scan 'ipd'
checkout.scan 'ipd'

checkout.total
=> '$2718.95'

# Example 3:  a free VGA adapter will be included, if a customer buys a MacBook Pro
# SKUs Scanned: mbp, vga, ipd
# Total expected: $1949.98
checkout = Checkout.new(pricing_rules: pricing_rules)
checkout.scan 'mbp'
checkout.scan 'vga'
checkout.scan 'ipd'

checkout.total
=> '$1949.98'