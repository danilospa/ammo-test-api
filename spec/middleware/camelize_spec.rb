# frozen_string_literal: true

require './app/middlewares/camelize'

RSpec.describe Middlewares::Camelize do
  def app
    Class.new(Application) do
      use Middlewares::Camelize

      get '/json' do
        {
          first_field: 'value',
          other_field: {
            first_nested_field: 2,
            array_field: [
              2,
              [{ nested_field_inside_array: 1 }],
              { other_field: 1 }
            ]
          }
        }.to_json
      end

      get '/string' do
        'oi'
      end
    end
  end

  context 'when response is json' do
    let(:expected_json) do
      {
        'firstField' => 'value',
        'otherField' => {
          'firstNestedField' => 2,
          'arrayField' => [
            2,
            [{ 'nestedFieldInsideArray' => 1 }],
            { 'otherField' => 1 }
          ]
        }
      }
    end

    before { get '/json' }

    it 'camelize response body fields' do
      expect(JSON.parse(last_response.body)).to eq expected_json
    end

    it 'sets correct content length header' do
      expect(last_response.headers['Content-length']).to eq '123'
    end
  end

  it 'ignores non json body' do
    get '/string'
    expect(last_response.body).to eq 'oi'
  end
end
