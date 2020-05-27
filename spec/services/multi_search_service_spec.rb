# frozen_string_literal: true

describe MultiSearchService do
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
      binding.pry
      MultiSearchService.call(order[:items], order[:shipping_region])
      # expect(SearchService.call(booking).first.delivery_times["us"]).to be 3
    end
  end
  
    # context "when having a t-shirt and hoodie in the basket" do  
    # let(:order) do
    #   {
    #     items:[
    #        {
    #           product_name: "pink_t-shirt",
    #           value: 2
    #        },
    #        {
    #           product_name: "black_mug",
    #           value: 2
    #        },
    #     ],
    #     shipping_region: "us"
    #   }
    # end
    # it "returns common supplier" do
    #   MultiSearchService.call(order[:items], order[:shipping_region])
    #   # expect(SearchService.call(booking).first.delivery_times["us"]).to be 3
    # end
    # end
end
