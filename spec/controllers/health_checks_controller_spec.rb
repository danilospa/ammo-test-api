# frozen_string_literal: true

require './app/controllers/health_checks_controller'

RSpec.describe HealthChecksController do
  let(:body) { JSON.parse(last_response.body) }

  describe 'get /' do
    before { get '/' }

    it 'returns status code 200' do
      expect(last_response.status).to eq 200
    end

    it 'returns correct body' do
      expect(body).to eq 'status' => 'OK'
    end
  end
end
