# frozen_string_literal: true

describe OrderPresenter do
  let(:order) do
    {
      items: [{ product_name: "pink_t-shirt",
                value: 2 },
              { product_name: "black_mug",
                value: 2 }],
      shipping_region: "eu"
    }
  end

  context "when having a t-shirt and hoodie in the basket" do
    let(:unpresented_data) { SearchService.new.call(order[:items], order[:shipping_region]) }
    let(:presented_data) { OrderPresenter.new(unpresented_data.flatten).call }
    let(:expected_data) do
      { delivery_date: (Date.today + 2 + 2).to_s,
        shipments: [{ supplier: "Best Tshirts",
                      delivery_date: (Date.today + 2 + 2).to_s,
                      items: [{ title: "pink_t-shirt", count: 2 }] },
                    { supplier: "Shirts Unlimited",
                      delivery_date: (Date.today + 2 + 1).to_s,
                      items: [{ title: "black_mug", count: 2 }] }] }
    end

    it "returns common supplier" do
      expect(presented_data).to include expected_data
    end
  end
end
