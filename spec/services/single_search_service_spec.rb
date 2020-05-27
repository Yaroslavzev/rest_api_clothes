# frozen_string_literal: true

describe SingleSearchService do
  let(:order) do
    {
      items: [
        {
          product_name: 'pink_t-shirt',
          value: 2
        }
      ],
      shipping_region: 'us'
    }
  end

  context 'when having product A from two suppliers A and B' do
    it 'returns the smallest supplier delivery time' do
      results = SingleSearchService.call(order[:items], order[:shipping_region])
      # TODO: add Date shipping
      expect(results[:delivery_date]).to eq(Date.today + 3 + 2)
    end
  end
end
