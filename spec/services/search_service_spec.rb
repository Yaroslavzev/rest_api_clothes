# frozen_string_literal: true

describe SearchService, aggregate_failures: true do
  subject(:results) { described_class.new.call(order[:items], order[:shipping_region]) }
  context "when one item in order" do
    let(:order) do
      {
        items: [{ product_name: product_name,
                  value: value }],
        shipping_region: "us"
      }
    end

    context "when having product A from two suppliers A and B" do
      let(:value) { 2 }
      let(:product_name) { "pink_t-shirt" }

      it "returns the smallest supplier delivery time" do
        expect(results.value!.flatten.count).to eq 1
        expect(results.value!.flatten.first[:delivery_time]).to eq 3
      end
    end

    context "when two shipments with 2 and 7 items from supplier A and B" do
      let(:value) { 9 }
      let(:product_name) { "pink_t-shirt" }

      it "returns the smallest supplier delivery time" do
        expect(results.value!.flatten.count).to eq 2
        expect(results.value!.flatten.first).to include(supplier: "Best Tshirts", delivery_time: 3, ordered_values: 2)
        expect(results.value!.flatten.second).to include(supplier: "Shirts4U", delivery_time: 6, ordered_values: 7)
      end
    end

    context "when three shipments with 2, 8 and 1 items from supplier A, B and C" do
      let(:value) { 11 }
      let(:product_name) { "pink_t-shirt" }

      it "returns the smallest supplier delivery time" do
        expect(results.value!.flatten.count).to eq 3
        expect(results.value!.flatten.first).to include(supplier: "Best Tshirts", ordered_values: 2)
        expect(results.value!.flatten.second).to include(supplier: "Shirts4U", delivery_time: 6, ordered_values: 8)
        expect(results.value!.flatten.third).to include(supplier: "Shirts4U and me",
                                                        delivery_time: 6,
                                                        ordered_values: 1)
      end
    end

    context "when doesn't have enough in stock" do
      let(:value) { 100 }
      let(:product_name) { "pink_t-shirt" }

      it "returns failure error" do
        expect(results).to be_failure
        expect(results.failure). to eq [:doesnt_have_enough_in_stock, { product_name: order.dig(:items, 0, :product_name) }]
      end
    end

    context "when product doesn't exist" do
      let(:product_name) { "kek" }
      let(:value) { 2 }

      it "returns failure error" do
        expect(results).to be_failure
        expect(results.failure). to eq [:not_found, { product_name: order.dig(:items, 0, :product_name) }]
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

          expect(results.value!.flatten.count).to be 2
          expect(results.value!.flatten.first[:supplier]).to eql "Best Tshirts"
          expect(results.value!.flatten.second[:supplier]).to eql "Shirts Unlimited"
        end
      end
    end
  end
end
