# frozen_string_literal: true

class StocksController < ApplicationController

  def in_stocks
    @stocks = SearchService.call(stock_params[:items], stock_params[:shipping_region])

    render json: OrderPresenter.new(@stocks.flatten).call
  end

  private

  def stock_params
    params.require(:order).permit(:shipping_region, items: %i[product_name value])
  end
end
