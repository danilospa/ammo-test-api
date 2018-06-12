# frozen_string_literal: true

require './lib/services/product'

module V1
  class ProductsController < Application
    get '/products' do
      search_term = params[:q]
      page_size = params.fetch(:page_size, 10)
      page = params.fetch(:page, 1)
      products = Services::Product.new.search_by_name(term: search_term, page_size: page_size.to_i, page: page.to_i)
      { products: products }.to_json
    end
  end
end
