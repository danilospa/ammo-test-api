# frozen_string_literal: true

require './lib/services/product'

RSpec.describe Services::Product do
  let(:search_service) { double('SearchService') }
  let(:cache_service) { double('CacheService') }

  subject { described_class.new(cache_service, search_service) }

  describe '#search_by_name' do
    before do
      allow(search_service).to receive(:search).and_return([])
    end

    it 'searches without query when no term is provided' do
      expect(search_service).to receive(:search).with(hash_not_including(query: anything))
      subject.search_by_name
    end

    it 'searches with query when a term is provided' do
      expect(search_service).to receive(:search).with(hash_including(query: { match: { name: 'name' } }))
      subject.search_by_name(term: 'name')
    end

    it 'sorts by id' do
      expect(search_service).to receive(:search).with(hash_including(sort: ['id']))
      subject.search_by_name
    end

    it 'sets specified page size' do
      expect(search_service).to receive(:search).with(hash_including(size: 5))
      subject.search_by_name(page_size: 5)
    end

    it 'sets specified offset' do
      expect(search_service).to receive(:search).with(hash_including(from: 10))
      subject.search_by_name(page_size: 5, page: 3)
    end

    it 'gets products for results' do
      allow(search_service).to receive(:search).and_return([ { '_id' => 1 }])
      expect(subject).to receive(:get).with(1)
      subject.search_by_name
    end

    it 'returns products' do
      allow(search_service).to receive(:search).and_return([ { '_id' => 1 }])
      expect(subject).to receive(:get).and_return('product from cache')
      expect(subject.search_by_name).to eq ['product from cache']
    end
  end

  describe '#get' do
    it 'gets product from cache service' do
      expect(cache_service).to receive(:get).with('id').and_return({}.to_json)
      subject.get('id')
    end

    it 'returns product' do
      allow(cache_service).to receive(:get).and_return({ 'name' => 'product name' }.to_json)
      expect(subject.get('id')).to eq 'name' => 'product name'
    end
  end
end
