# frozen_string_literal: true

require './application'

Dir.glob('./app/controllers/**/*.rb').each { |file| require file }

use HealthChecksController

map '/v1' do
  use V1::ProductsController
end

run Application
