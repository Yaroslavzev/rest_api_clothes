# frozen_string_literal: true

require "dry/monads"
require "dry/monads/do"

module API
  module V1
    module Stocks
      class GetOperation
        include Dry::Monads[:result, :do]
        include Dry::Monads::Do.for(:call)

        include AppImport[contract: "api.v1.stocks.contracts.get_stocks",
                          search_suppliers: "search_service",
                          presenter: "order_presenter"
                ]

        def call(params)
          contract_params = yield validate_data(params)
          contract_params = contract_params[:order]

          result = yield search_suppliers.call(contract_params[:items], contract_params[:shipping_region])
          #TODO: remove flatten
          result = yield presenter.call(target: result.flatten)

          Success(result)
        end

        private

        def validate_data(params)
          result = contract.call(params)

          return Success(result.to_h) if result.success?

          Failure[:unprocessable_entity, result.errors.to_h]
        end
      end
    end
  end
end
