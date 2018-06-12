require 'json'
ENV['RACK_ENV'] = 'development' unless ENV.include?('RACK_ENV')

require './lib/services/cache'
require './lib/services/search'

indexed_fields = %w[id name]
products = [
  {
    id: 1,
    name: 'Cama grande',
    old_price: 100.00,
    current_price: 55.55,
  },
  {
    id: 2,
    name: 'Cama pequena',
    old_price: 100.00,
    current_price: 55.55,
  },
  {
    id: 3,
    name: 'Toalha lisa',
    old_price: 50.00,
    current_price: 10.55,
  },
  {
    id: 4,
    name: 'Toalha escura',
    old_price: 20.00,
    current_price: 10.00,
  },
]

products.each do |product|
  indexed_product = product.select { |k, _| indexed_fields.include?(k.to_s) }
  Services::Search.new.index('product', product[:id], indexed_product)
  Services::Cache.new.set(product[:id], product.to_json)
end
