# frozen_string_literal: true

require "swagger_helper"

RSpec.describe API::V1::StocksController, type: :request do
  path "/api/v1/in_stocks" do
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
        },
        required: true
      }

      response(200, "successful") do
        schema type: :object,
               properties: {
                 delivery_date: { type: :string },
                 shipments: {
                   type: Array,
                   properties: {
                     supplier: { type: :string },
                     delivery_date: { type: :string },
                     items: {
                       type: Array,
                       properties: {
                         title: { type: :string },
                         count: { type: :int }
                       },
                       required: %w[title count]
                     }
                   },
                   required: %w[supplier delivery_date items]
                 }
               },
               required: %w[delivery_date shipments]

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

      response(422, "unprocessable entity") do
        let(:order) do
          { order: {
            items: [
              {
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
