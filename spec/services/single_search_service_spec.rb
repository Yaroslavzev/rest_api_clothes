# frozen_string_literal: true

describe SingleSearchService do
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
      results = SingleSearchService.call(order[:items], order[:shipping_region])

      expect(results.flatten.count).to eq 1
      expect(results.flatten.first[:delivery_date]).to eq(Date.today + 3 + 2)
    end
  end

  context "when two shipments with 2 and 7 items from supplier A and B" do
    let(:value) { 9 }

    it "returns the smallest supplier delivery time" do
      results = SingleSearchService.call(order[:items], order[:shipping_region])

      expect(results.flatten.count).to eq 2
      expect(results.flatten.first).to include(supplier: "Best Tshirts", delivery_date: Date.today + 3 + 2, value: 2)
      expect(results.flatten.second).to include(supplier: "Shirts4U", delivery_date: Date.today + 6 + 2, value: 7)    
    end
  end

  context "when three shipments with 2, 8 and 1 items from supplier A, B and C" do
    let(:value) { 11 }

    it "returns the smallest supplier delivery time" do
      results = SingleSearchService.call(order[:items], order[:shipping_region])

      expect(results.flatten.count).to eq 3
      expect(results.flatten.first).to include(supplier: "Best Tshirts", value: 2)
      expect(results.flatten.second).to include(supplier: "Shirts4U", delivery_date: Date.today + 6 + 2, value: 8)
      expect(results.flatten.third).to include(supplier: "Shirts4U and me", delivery_date: Date.today + 6 + 2, value: 1)
    end
  end
end
