# frozen_string_literal: true

class StocksController < ApplicationController
  def index
    @stocks = ResolverService.call(stock_params)

    render json: OrderPresenter.new(@stocks.flatten).call
  end

  private

  def stock_params
    params.require(:order).permit(:shipping_region, items: %i[product_name value])
  end
end
