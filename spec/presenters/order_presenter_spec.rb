# frozen_string_literal: true

describe OrderPresenter do
  subject(:result) { described_class.new.call(target: suppliers_with_staff.flatten) }
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
    # TODO: use instance_double
    let(:suppliers_with_staff) { AppContainer["search_service"].call(order[:items], order[:shipping_region]).value! }
    let(:expected_data) do
      { delivery_date: (Date.today + 2 + 2).to_s,
        shipments: [{ supplier: "Best Tshirts",
                      delivery_date: (Date.today + 2 + 2).to_s,
                      items: [{ title: "pink_t-shirt", count: 2 }] },
                    { supplier: "Shirts Unlimited",
                      delivery_date: (Date.today + 2 + 1).to_s,
                      items: [{ title: "black_mug", count: 2 }] }] }
    end

    it "returns common supplier", aggregate_failures: true do
      expect(result).to be_success
      expect(result.value!).to include expected_data
    end
  end
end
