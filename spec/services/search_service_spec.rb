# frozen_string_literal: true

describe SearchService do
  let(:init_order) do
    {
      items:[
         {
            product_name: "pink_t-shirt",
            value: 2
         }
      ],
      shipping_region: "us"
    }
  end

  context "when having product A from two suppliers A and B" do
    it "returns the smallest supplier delivery time" do
      expect(SearchService.call(init_order).first.delivery_times["us"]).to be 3
    end
  end
  
  context "when having a t-shirt and hoodie in the basket" do
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
    
    it "returns common supplier" do
      SearchService.call(order)
      # expect(SearchService.call(booking).first.delivery_times["us"]).to be 3
    end
  end
end
