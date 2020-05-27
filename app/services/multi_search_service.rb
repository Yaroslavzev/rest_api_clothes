# frozen_string_literal: true

class MultiSearchService < BaseSearchService
  def call
    items_by_one = Stock.yield_self(&method(:suppliers))
                       .yield_self(&method(:find_common_suppliers))

    items_by_one = results(items_by_one)
    
    items_by_many = items.map do |order| 
      SingleSearchService.call([order], shipping_region)
    end

    date = max_delivery_date(items_by_many, items_by_one)
    
    return items_by_one if date[:delivery_date] <= date[:max_delivery_date]
    items_by_many
  end

  private
  
  def max_delivery_date(items_by_many, items_by_one)
    items_by_many.each_with_object(delivery_date: items_by_one[:delivery_date])  do |k, hash|
      hash[:max_delivery_date] = k[:delivery_date] if hash[:delivery_date] <= k[:delivery_date]
    end
  end
    
  def suppliers(scope)
    queries = super
    Stock.from("(#{queries[0].to_sql} UNION #{queries[1].to_sql}) as stocks")
  end
  
  
  def find_common_suppliers(scope)
    scope.select(<<~SQL.squish
      *,
      dense_rank() OVER (
        PARTITION BY stocks.product_name 
        ORDER BY stocks.supplier) AS number_items
    SQL
  ).order(number_items: :desc)
   .first
  end

end
