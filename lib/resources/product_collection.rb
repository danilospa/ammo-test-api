# frozen_string_literal: true

module Resources
  class ProductCollection
    attr_accessor :products, :total, :page_size

    def initialize(products, total, page_size)
      @products = products
      @total = total
      @page_size = page_size
    end

    def to_hash
      {
        products: products,
        total: total,
        pages: total.zero? ? 0 : (total.to_f / page_size).ceil
      }
    end
  end
end
