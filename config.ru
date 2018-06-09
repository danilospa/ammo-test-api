# frozen_string_literal: true

require './application'

Dir.glob('./app/controllers/*.rb').each { |file| require file }

use HealthChecksController
run Application
