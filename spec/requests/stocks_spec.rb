# frozen_string_literal: true

RSpec.describe "/stocks" do
  describe "GET /index" do
    let(:params) do
      { params: { order: {
        items: [
          {
            product_name: "pink_t-shirt",
            value: 2
          }
        ],
        shipping_region: "us"
      }, format: :json } }
    end

    it "renders a successful response" do
      # Stock.create! valid_attributes
      # headers = { "ACCEPT" => "application/json" }
      get stocks_path, params
      # binding.pry
      # , headers: headers
      # post stocks_url
      # post "/stocks", init_order #:index, init_order #, :headers => headers
      # binding.pry

      # get "/stocks", headers: valid_headers, params: { product_name: "T-shirt", as: :json }
      # ap response.body
      # expect(response).to be_successful
    end
  end
end
