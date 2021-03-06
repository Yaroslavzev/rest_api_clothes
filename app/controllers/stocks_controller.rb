# frozen_string_literal: true

class StocksController < ApplicationController
  include Dry::Monads[:result]

  include AppImport[get_operation: "api.v1.stocks.get_operation"]

  def in_stocks
    # stock_params = get_stocks.call(params.to_unsafe_h)
    # stock_params = stock_params[:order]
    # @stocks = SearchService.call(stock_params[:items], stock_params[:shipping_region])
    result = get_operation.call(params.to_unsafe_h)

    case result
    in Success(values)
      render json: values
    in Failure()

    end
  end
end
