# frozen_string_literal: true

module Middlewares
  class Camelize
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      hash = JSON.parse(body[0], symbolize_names: true)
      transformed_body = deep_camelize(hash).to_json
      headers['Content-Length'] = transformed_body.length.to_s

      [status, headers, [transformed_body]]
    rescue JSON::ParserError
      [status, headers, body]
    end

    def deep_camelize(hash)
      hash.each_with_object({}) do |item, obj|
        k, v = item
        key = camelize(k.to_s)
        value = if v.is_a?(Array)
                  deep_camelize_array(v)
                elsif v.is_a?(Hash)
                  deep_camelize(v)
                else
                  v
                end
        obj[key] = value
      end
    end

    def deep_camelize_array(array)
      array.map do |item|
        value = if item.is_a?(Array)
                  deep_camelize_array(item)
                elsif item.is_a?(Hash)
                  deep_camelize(item)
                else
                  item
                end
        value
      end
    end

    def camelize(string)
      string.gsub(/_[a-z]/) { $&[1].capitalize }
    end
  end
end
