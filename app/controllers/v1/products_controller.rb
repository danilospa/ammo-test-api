# frozen_string_literal: true

require './lib/services/product'

module V1
  class ProductsController < Application
    get '/products' do
      search_term = params[:q]
      products = Services::Product.new.search_by_name(term: search_term)
      { products: products }.to_json
    end
  end
end
