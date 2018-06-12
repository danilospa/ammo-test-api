# frozen_string_literal: true

require './app/controllers/v1/products_controller'

RSpec.describe V1::ProductsController do
  let(:body) { JSON.parse(last_response.body) }

  describe 'get /products' do
    products = [
      { id: 1, name: 'Cama grande' },
      { id: 2, name: 'Cama pequena' }
    ]
    cache_service = Services::Cache.new
    search_service = Services::Search.new
    wait_for_index = lambda do |index:, id:|
      while !search_service.client.exists?(index: index, id: id); end
    end

    before :all do
      products.each do |product|
        id = product[:id]
        search_service.index('product', id, product)
        cache_service.set(id, product.to_json)
        wait_for_index.call(index: Services::Search::INDEX_NAME, id: id)
      end
    end
    after :all do
      search_service.delete_index
      products.each { |p| cache_service.del(p[:id]) }
    end

    context 'when no search term is provided' do
      before { get '/products' }

      it 'returns status code 200' do
        expect(last_response.status).to eq 200
      end

      it 'returns all products' do
        expected_products = products.map { |p| JSON.parse(p.to_json) }
        expect(body).to eq 'products' => expected_products
      end
    end

    context 'when search term is provided' do
      context 'when a product is found' do
        before { get '/products', q: 'grande' }

        it 'returns status code 200' do
          expect(last_response.status).to eq 200
        end

        it 'returns found products' do
          expected_product = JSON.parse(products[0].to_json)
          expect(body).to eq 'products' => [expected_product]
        end
      end

      context 'when no product is found' do
        before { get '/products', q: 'colchao' }

        it 'returns status code 200' do
          expect(last_response.status).to eq 200
        end

        it 'returns correct products' do
          expect(body).to eq 'products' => []
        end
      end
    end
  end
end
