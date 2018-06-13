# frozen_string_literal: true

require './lib/services/product'
require './lib/resources/product_collection'

module V1
  class ProductsController < Application
    get '/products' do
      search_term = params[:q]
      page_size = params.fetch(:pageSize, 10).to_i
      page = params.fetch(:page, 1).to_i
      response = Services::Product.new.search_by_name(term: search_term, page_size: page_size, page: page)
      Resources::ProductCollection.new(*response.values, page_size).to_hash.to_json
    end
  end
end
