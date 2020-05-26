# frozen_string_literal: true

class SearchService < ApplicationService
  attr_reader :search

  def initialize(search)
    @search = search
  end

  def call
    Stock.yield_self(&method(:suppliers))
         .yield_self(&method(:find_common_suppliers))
         .yield_self(&method(:departure_country))

  end

  private

  def suppliers(scope)
    queries = search[:items].map do |order| 
      scope.where(product_name: order[:product_name])
           .where(":value <= in_stock", value: order[:value]) 
                   
         end

    scope = Stock.from("(#{queries[0].to_sql} UNION #{queries[1].to_sql}) as stocks")

    scope
  end
  
  def departure_country(scope)
    shipping_region = ActiveRecord::Base.connection.quote(search[:shipping_region])

    scope = scope.order("(delivery_times ->> #{shipping_region})::Integer ASC").first
     scope
  end
  
  def find_common_suppliers(scope)
    suppliers = scope.select(<<~SQL.squish
      *,
      dense_rank() OVER (
        PARTITION BY stocks.product_name 
        ORDER BY stocks.supplier) AS number_items
    SQL
  ).order(number_items: :desc)
   .first
    
    # binding.pry
    # ap nn.to_sql
    scope
  end

end
