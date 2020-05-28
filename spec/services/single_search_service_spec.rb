# frozen_string_literal: true

describe SingleSearchService do
  let(:order) do
    {
      items: [
        {
          product_name: "pink_t-shirt",
          value: value
        }
      ],
      shipping_region: "us"
    }
  end

  context "when having product A from two suppliers A and B" do
    let(:value) { "2" }

    it "returns the smallest supplier delivery time" do
      results = SingleSearchService.call(order[:items], order[:shipping_region])
      # TODO: add Date shipping
      expect(results.count).to eq 1
      expect(results.first[:delivery_date]).to eq(Date.today + 3 + 2)
    end
  end

  context "when two shipments with 2 and 7 items from supplier A and B" do
    let(:value) { "9" }

    it "returns the smallest supplier delivery time" do
      results = SingleSearchService.call(order[:items], order[:shipping_region])
      # TODO: add Date shipping
      expect(results.count).to eq 2
    end
  end
end
