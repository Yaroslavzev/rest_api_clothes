# frozen_string_literal: true

describe SearchService do
  context "when one item in order" do
    let(:order) do
      {
        items: [{ product_name: "pink_t-shirt",
                  value: value }],
        shipping_region: "us"
      }
    end

    context "when having product A from two suppliers A and B" do
      let(:value) { 2 }

      it "returns the smallest supplier delivery time" do
        results = SearchService.new.call(order[:items], order[:shipping_region])

        expect(results.flatten.count).to eq 1
        # expect(results.flatten.first[:delivery_date]).to eq(Date.today + 3 + 2)
      end
    end

    context "when two shipments with 2 and 7 items from supplier A and B" do
      let(:value) { 9 }

      it "returns the smallest supplier delivery time" do
        results = SearchService.new.call(order[:items], order[:shipping_region])

        expect(results.flatten.count).to eq 2
        # expect(results.flatten.first).to include(supplier: "Best Tshirts", delivery_date: Date.today + 3 + 2, value: 2)
        # expect(results.flatten.second).to include(supplier: "Shirts4U", delivery_date: Date.today + 6 + 2, value: 7)
      end
    end

    context "when three shipments with 2, 8 and 1 items from supplier A, B and C" do
      let(:value) { 11 }

      it "returns the smallest supplier delivery time", aggregate_failures: true do
        results = SearchService.new.call(order[:items], order[:shipping_region])

        expect(results.flatten.count).to eq 3
        # expect(results.flatten.first).to include(supplier: "Best Tshirts", value: 2)
        # expect(results.flatten.second).to include(supplier: "Shirts4U", delivery_date: Date.today + 6 + 2, value: 8)
        # expect(results.flatten.third).to include(supplier: "Shirts4U and me",
        #                                          delivery_date: Date.today + 6 + 2,
        #                                          value: 1)
      end
    end
  end

  context "when several items in order" do
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

        # it "returns common supplier" do
        #   results = SearchService.new.call(order[:items], order[:shipping_region])
        #
        #   expect(results.flatten.count).to be 2
        #   expect(results.flatten.first[:supplier]).to eql "Shirts4U"
        #   expect(results.flatten.second[:supplier]).to eql "Shirts4U"
        # end

        # context "when one supplier doesn't have enough items in stock" do
        #   let(:value) { 6 }
        #
        #   it "returns two suppliers" do
        #     results = SearchService.new.call(order[:items], order[:shipping_region])
        #
        #     expect(results.flatten.count).to be 3
        #     expect(results.flatten.first[:supplier]).to eql "Shirts4U"
        #     expect(results.flatten.second[:supplier]).to eql "Shirts4U"
        #     expect(results.flatten.third[:supplier]).to eql "Shirts Unlimited"
        #   end
        # end
      end

      context "when delivery by several suppliers faster than by one" do
        let(:shipping_region) { "eu" }
        let(:value) { 2 }

        it "returns two supplier" do
          results = SearchService.new.call(order[:items], order[:shipping_region])

          expect(results.flatten.count).to be 2
          # expect(results.flatten.first[:supplier]).to eql "Best Tshirts"
          # expect(results.flatten.second[:supplier]).to eql "Shirts Unlimited"
        end
      end
    end
  end
end
