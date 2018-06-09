# frozen_string_literal: true

class HealthChecksController < Application
  get '/' do
    { status: 'OK' }.to_json
  end
end
