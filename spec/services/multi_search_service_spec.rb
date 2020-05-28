# frozen_string_literal: true

describe MultiSearchService do
  let(:order) do
    {
      items: [
        {
          product_name: "pink_t-shirt",
          value: 2
        },
        {
          product_name: "black_mug",
          value: 2
        }
      ],
      shipping_region: shipping_region
    }
  end

  context "having a t-shirt and hoodie in the basket" do
    context "when delivery by one supplier faster than by many" do
      let(:shipping_region) { "us" }

      it "returns common supplier" do
        result = MultiSearchService.call(order[:items], order[:shipping_region])

        expect(result.flatten.count).to be 1
      end
    end

    context "when delivery by several suppliers faster than by one" do
      let(:shipping_region) { "eu" }

      it "returns two supplier" do
        result = MultiSearchService.call(order[:items], order[:shipping_region])

        expect(result.flatten.count).to be 2
      end
    end
  end

  # context 'when having a t-shirt and hoodie in the basket' do
  #     let(:order) do
  #       {
  #         items: [
  #           {
  #             product_name: 'pink_t-shirt',
  #             value: 2
  #           },
  #           {
  #             product_name: 'black_mug',
  #             value: 2
  #           },
  #           {
  #             product_name: 'blue_t-shirt',
  #             value: 2
  #           }
  #         ],
  #         shipping_region: shipping_region
  #       }
  #     end
  #
  #   let(:shipping_region) { "us" }
  #
  #   it 'returns common supplier' do
  #     # result = MultiSearchService.call(order[:items], order[:shipping_region])
  #     # binding.pry
  #     # expect(result.flatten.count).to be 2
  #   end
  # end
end
