# frozen_string_literal: true

module API
  module V1
    module Stocks
      module Contracts
        class GetStocks < Dry::Validation::Contract
          params do
            required(:order).hash do
              required(:shipping_region).filled(:str?)
              required(:items).array(:hash) do
                required(:product_name).filled(:str?)
                required(:value).filled(:integer, gt?: 0)
              end
            end
          end
        end
      end
    end
  end
end
