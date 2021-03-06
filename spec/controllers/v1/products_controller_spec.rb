# frozen_string_literal: true

require './app/controllers/v1/products_controller'

RSpec.describe V1::ProductsController do
  let(:body) { JSON.parse(last_response.body) }

  describe 'get /products' do
    products = [
      { id: 1, name: 'Cama grande' },
      { id: 2, name: 'Cama pequena' },
      { id: 3, name: 'toalha pequena' }
    ]
    cache_service = Services::Cache.new
    search_service = Services::Search.new

    before :all do
      products.each do |product|
        id = product[:id]
        search_service.index('product', id, product)
        cache_service.set(id, product.to_json)
      end
      search_service.client.indices.flush(index: Services::Search::INDEX_NAME)
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
        expect(body).to eq 'products' => expected_products, 'total' => 3, 'pages' => 1
      end
    end

    context 'when specifying a page number and a page size' do
      before { get '/products', pageSize: 1, page: 2 }

      it 'returns status code 200' do
        expect(last_response.status).to eq 200
      end

      it 'returns results paginated' do
        expected_product = JSON.parse(products[1].to_json)
        expect(body).to eq 'products' => [expected_product], 'total' => 3, 'pages' => 3
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
          expect(body).to eq 'products' => [expected_product], 'total' => 1, 'pages' => 1
        end
      end

      context 'when no product is found' do
        before { get '/products', q: 'colchao' }

        it 'returns status code 200' do
          expect(last_response.status).to eq 200
        end

        it 'returns no products' do
          expect(body).to eq 'products' => [], 'total' => 0, 'pages' => 0
        end
      end
    end
  end
end
