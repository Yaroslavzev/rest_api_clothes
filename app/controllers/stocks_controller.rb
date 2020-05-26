# frozen_string_literal: true

class StocksController < ApplicationController
  # before_action :set_stock, only: [:show, :update, :destroy]

  # GET /stocks
  def index
    # binding.pry
    @stocks = ResolverService.call(stock_params)
    # OrderPresenter
    # Stock.all
    
    # binding.pry
    @nnn=OrderPresenter.new(@stocks).call
    render json: @nnn
  end

  # GET /stocks/1
  def show
    binding.pry
    render json: @stock
  end
  # 
  # POST /stocks
  def create
    binding.pry
    @stock = Stock.new(stock_params)
  
    if @stock.save
      render json: @stock, status: :created, location: @stock
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /stocks/1
  def update
    binding.pry
    if @stock.update(stock_params)
      render json: @stock
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end
  
  # DELETE /stocks/1
  def destroy
    @stock.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def stock_params
      # booking: {orders: [{ product_name: "pink_t-shirt", value: 2}], destination: "us"}
      params.require(:order).permit(:shipping_region, items: [:product_name, :value])
    end
end
