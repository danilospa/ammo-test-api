# frozen_string_literal: true

require 'redis'

module Services
  class Cache
    @@client = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])
    PROXIED_METHODS = %w[get set del]

    def initialize(client = @@client)
      @client = client
    end

    PROXIED_METHODS.each do |method|
      define_method method do |*args|
        @client.send(method, *args)
      end
    end
  end
end
