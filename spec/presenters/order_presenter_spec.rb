# frozen_string_literal: true

describe OrderPresenter do
  let(:order) do
    {
      items: [
        {
          product_name: 'pink_t-shirt',
          value: 2
        },
        {
          product_name: 'black_mug',
          value: 2
        }
      ],
      shipping_region: "eu"
    }
  end

  context 'when having a t-shirt and hoodie in the basket' do
    it 'returns common supplier' do
      qwerty = MultiSearchService.call(order[:items], order[:shipping_region])
      hash = {:id=>6, :product_name=>"pink_t-shirt", :supplier=>"Best Tshirts", :delivery_date=>Date.today, :value=>2}
      # binding.pry
      qwerty = qwerty.flatten << hash
      binding.pry
     
      # TODO remove flatten
      OrderPresenter.new(qwerty).call
      # expect(SearchService.call(booking).first.delivery_times["us"]).to be 3
    end
  end
end
