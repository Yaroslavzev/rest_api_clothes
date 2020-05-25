# frozen_string_literal: true

class SearchService < ApplicationService
  attr_reader :search

  def initialize(search)
    @search = search
  end

  def call
    # binding.pry
    Stock.yield_self(&method(:suppliers))
         .yield_self(&method(:find_common_suppliers))
         .yield_self(&method(:departure_country))
         # .yield_self(&method(:search_places))
  end

  private

  def suppliers(scope)
    queries = search[:items].map do |order| 
      scope.where(product_name: order[:product_name])
           .where(":value <= in_stock", value: order[:value]) 
                   
         end

    return queries[0] if search[:items].count == 0
    scope = Stock.from("(#{queries[0].to_sql} UNION #{queries[1].to_sql}) as stocks")

    scope
  end
  
  def departure_country(scope)
    # ActiveRecord::Base.connection.quote(search[:destination])
    # sanitize = sanitize_sql_array("delivery_times->> \:country_code", country_code: sanitize_sql_like(search[:destination]))
    shipping_region = ActiveRecord::Base.connection.quote(search[:shipping_region])
    # binding.pry
    
    scope = scope.order("(delivery_times ->> #{shipping_region})::Integer ASC")
    # scope = scope.where("delivery_times ? :bb", bb: search[:destination])
    # scope = scope.order("(delivery_times ->> 'us')::Integer ASC")
    
    # Stock.where("delivery_times ? 'uk'")
    # ("delivery_times->>'kind' = ?", "us")
    # minimum("delivery_times->>:country_code", country_code: search[:destination])
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
      
      binding.pry
      ap nn.to_sql
      scope
    end
    
    def search_places(scope)

  # select(<<-SQL
  #   therapists.*,
  #   point(locations.longitude, locations.latitude) <@> point(#{longitude}, #{latitude}) as distance,
  #   dense_rank() OVER (
  #     PARTITION BY therapists.id
  #     ORDER BY point(locations.longitude, locations.latitude) <@> point(#{longitude}, #{latitude})
  #   ) AS distance_rank
  # SQL
  # ).joins(:locations).

  end
end
