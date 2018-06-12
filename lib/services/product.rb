# frozen_string_literal: true

require_relative './cache'
require_relative './search'

module Services
  class Product
    def initialize(cache_service = Cache.new, search_service = Search.new)
      @cache_service = cache_service
      @search_service = search_service
    end

    def search_by_name(term: nil)
      query = if term.nil?
                {}
              else
                {
                  match: {
                    name: term
                  }
                }
              end
      response = @search_service.search(query: query, sort: ['id'])
      response.map { |result| get(result['_id']) }
    end

    def get(id)
      JSON.parse(@cache_service.get(id))
    end
  end
end
