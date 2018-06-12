# frozen_string_literal: true

require './lib/services/cache'

RSpec.describe Services::Cache do
  let(:client) { double('CacheClient') }

  subject { described_class.new(client) }

  described_class::PROXIED_METHODS.each do |method|
    describe '#' + method do
      it 'calls method with correct args' do
        first_arg = 1
        second_arg = 2
        expect(client).to receive(method).with(first_arg, second_arg)
        subject.send(method, first_arg, second_arg)
      end

      it 'returns correct value' do
        allow(client).to receive(method).and_return('response')
        expect(subject.send(method)).to eq 'response'
      end
    end
  end
end
