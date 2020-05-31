# frozen_string_literal: true

describe MultiSearchService do
  let(:order) do
    {
      items: [{ product_name: "pink_t-shirt",
                value: 2 },
              { product_name: "black_mug",
                value: value }],
      shipping_region: shipping_region
    }
  end

  context "having a t-shirt and hoodie in the basket" do
    context "when delivery by one supplier faster than by many" do
      let(:shipping_region) { "us" }
      let(:value) { 2 }

      it "returns common supplier" do
        results = MultiSearchService.call(order[:items], order[:shipping_region])

        expect(results.flatten.count).to be 2
        expect(results.flatten.first[:supplier]).to eql "Shirts4U"
        expect(results.flatten.second[:supplier]).to eql "Shirts4U"
      end

      context "when one supplier doesn't have enough items in stock" do
        let(:value) { 6 }

        it "returns two suppliers" do
          results = MultiSearchService.call(order[:items], order[:shipping_region])

          expect(results.flatten.count).to be 3
          expect(results.flatten.first[:supplier]).to eql "Shirts4U"
          expect(results.flatten.second[:supplier]).to eql "Shirts4U"
          expect(results.flatten.third[:supplier]).to eql "Shirts Unlimited"
        end
      end
    end

    context "when delivery by several suppliers faster than by one" do
      let(:shipping_region) { "eu" }
      let(:value) { 2 }

      it "returns two supplier" do
        results = MultiSearchService.call(order[:items], order[:shipping_region])

        expect(results.flatten.count).to be 2
        expect(results.flatten.first[:supplier]).to eql "Best Tshirts"
        expect(results.flatten.second[:supplier]).to eql "Shirts Unlimited"
      end
    end
  end
end
