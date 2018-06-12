# frozen_string_literal: true

require 'elasticsearch'

module Services
  class Search
    attr_reader :client

    @@client = Elasticsearch::Client.new(host: ENV['ELASTICSEARCH_HOST'], port: ENV['ELASTICSEARCH_PORT'])
    INDEX_NAME = "website-#{ENV['RACK_ENV']}"

    def initialize(client = @@client)
      @client = client
    end

    def search(query)
      @client.search(index: INDEX_NAME, body: query)['hits']
    end

    def index(type, id, body)
      @client.index(index: INDEX_NAME, type: type, id: id, body: body)
    end

    def delete_index
      @client.indices.delete(index: INDEX_NAME)
    end
  end
end
