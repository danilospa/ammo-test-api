# frozen_string_literal: true

module Middlewares
  class Cors
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env).tap do |_status, headers, _body|
        headers['Access-Control-Allow-Origin'] = '*'
      end
    end
  end
end
