# frozen_string_literal: true

require './app/middlewares/cors'

RSpec.describe Middlewares::Cors do
  def app
    Class.new(Application) do
      use Middlewares::Cors
    end
  end

  it 'adds correct cors headers with correct value' do
    get '/'
    expect(last_response.headers['Access-Control-Allow-Origin']).to eq '*'
  end
end
