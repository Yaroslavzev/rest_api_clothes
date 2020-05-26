# frozen_string_literal: true

class SingleSearchService < ApplicationService
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def call
    Stock.yield_self(&method(:suppliers))
         .yield_self(&method(:departure_country))
  end

  private

  def suppliers(scope)
    scope.where(product_name: order[:product_name])
         .where(":value <= in_stock", value: order[:value]) 

    scope
  end
  
  def departure_country(scope)
    shipping_region = ActiveRecord::Base.connection.quote(order[:shipping_region])
    
    scope = scope.order("(delivery_times ->> #{shipping_region})::Integer ASC").first
    scope
  end
end
