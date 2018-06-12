# frozen_string_literal: true

require_relative './cache'
require_relative './search'

module Services
  class Product
    def initialize(cache_service = Cache.new, search_service = Search.new)
      @cache_service = cache_service
      @search_service = search_service
    end

    def search_by_name(term: nil, page_size: 10, page: 1)
      definition = {
        sort: ['id'],
        size: page_size,
        from: (page - 1) * page_size

      }
      definition[:query] = {
        match: { name: term }
      } unless term.nil?

      response = @search_service.search(definition)
      {
        products: response['hits'].map { |result| get(result['_id']) },
        total: response['total']
      }
    end

    def get(id)
      JSON.parse(@cache_service.get(id))
    end
  end
end
