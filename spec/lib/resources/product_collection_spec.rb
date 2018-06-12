# frozen_string_literal: true

require './lib/resources/product_collection'

RSpec.describe Resources::ProductCollection do
  let(:products) { ['first_product', 'second_product'] }
  let(:total) { 10 }
  let(:page_size) { 3 }

  subject { described_class.new(products, total, page_size) }

  describe '#to_json' do
    it 'returns products' do
      expect(subject.to_hash[:products]).to eq products
    end

    it 'returns total value of products' do
      expect(subject.to_hash[:total]).to eq 10
    end

    it 'returns total pages' do
      expect(subject.to_hash[:pages]).to eq 4
    end

    it 'returns total pages as 0 when total is 0' do
      subject.total = 0
      expect(subject.to_hash[:pages]).to eq 0
    end

    it 'returns total pages as 1 when page size is greater then total' do
      subject.total = 5
      subject.page_size = 10
      expect(subject.to_hash[:pages]).to eq 1
    end
  end
end
