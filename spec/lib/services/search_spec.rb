# frozen_string_literal: true

require './lib/services/search'

RSpec.describe Services::Search do
  let(:client) { double('SearchClient') }

  subject { described_class.new(client) }

  describe '#search' do
    before do
      allow(client).to receive(:search).and_return('hits' => 'search results')
    end

    it 'calls search on client with correct arguments' do
      expect(client).to receive(:search).with(index: described_class::INDEX_NAME, body: 'body')
      subject.search('body')
    end

    it 'returns correct results' do
      expect(subject.search('body')).to eq 'search results'
    end
  end

  describe '#index' do
    it 'calls index on client with correct arguments' do
      expect(client).to receive(:index).with(index: described_class::INDEX_NAME, type: 'type', id: 'id', body: 'body')
      subject.index('type', 'id', 'body')
    end
  end

  describe '#delete_index' do
    it 'deletes specified index' do
      allow(client).to receive(:indices).and_return(client)
      expect(client).to receive(:delete).with(index: described_class::INDEX_NAME)
      subject.delete_index
    end
  end
end
