# frozen_string_literal: true

describe OrderPresenter do
  let(:order) do
    {
      items:[
         {
            product_name: "pink_t-shirt",
            value: 2
         },
         {
            product_name: "black_mug",
            value: 2
         },
      ],
      shipping_region: "us"
    }
  end
  
  context "when having a t-shirt and hoodie in the basket" do  
    it "returns common supplier" do
      qwerty = MultiSearchService.call(order[:items], order[:shipping_region])
      binding.pry
      OrderPresenter.new(qwerty).call
      # expect(SearchService.call(booking).first.delivery_times["us"]).to be 3
    end
  end
end
