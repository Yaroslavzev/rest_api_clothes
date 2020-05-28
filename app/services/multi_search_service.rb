# frozen_string_literal: true

class MultiSearchService < BaseSearchService
  def call
    items_by_one = Stock.yield_self(&method(:suppliers))
                        .yield_self(&method(:find_common_suppliers))
                        # .yield_self(&method(:count_items))
                        #.map{ |i| results(i) } # todo
    # binding.pry
    items_by_one = results(items_by_one)
    # binding.pry
    items_by_many = items.map do |order|
      # binding.pry
      SingleSearchService.call([order], shipping_region)
    end
    # binding.pry
    return [items_by_one] if items_by_one.first[:delivery_date] <= items_by_many.flatten.max_by{|k| k[:delivery_date] } [:delivery_date]
    items_by_many
  end

  private

  def suppliers(scope)
    queries = super
    # binding.pry
    Stock.from("(#{queries[0].to_sql} UNION #{queries[1].to_sql}) as stocks")
  end

  def find_common_suppliers(scope)
    # binding.pry
    scope = scope.select(<<~SQL.squish
      *,
      dense_rank() OVER (
        PARTITION BY stocks.product_name
        ORDER BY stocks.supplier) AS number_items
    SQL
                ).order(number_items: :desc)

    region = ActiveRecord::Base.connection.quote(shipping_region)


    scope = scope.order("(delivery_times ->> #{region})::Integer DESC")
    # binding.pry
    # TODO
    [scope[0]]
  end
end
