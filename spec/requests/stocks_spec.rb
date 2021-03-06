# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "stocks", type: :request do
  path "/in_stocks" do
    post("list stocks") do
      tags "Stock"
      produces "application/json"
      consumes "application/json"

      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          order: {
            items: {
              type: Array,
              properties: {
                product_name: { type: :string },
                value: { type: :int }
              }
            },
            shipping_region: { type: :string }
          }
          # required: [ 'items', 'product_name', 'value', ]
        },
        required: ["order"]
      }

      response(200, "successful") do
        let(:order) do
          { order: {
            items: [
              {
                product_name: "pink_t-shirt",
                value: 2
              }
            ],
            shipping_region: "us"
          } }
        end

        run_test!
      end
    end
  end
end
