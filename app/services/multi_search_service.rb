# frozen_string_literal: true

class MultiSearchService < BaseSearchService
  def call
    items_by_one = Stock.yield_self(&method(:suppliers))
                        .yield_self(&method(:find_common_suppliers))
    # .map{ |i| results(i) } # todo
    # изменить интерфейс в find_common_suppliers
    items_by_one = results(items_by_one)

    items_by_many = items.map do |order|
      SingleSearchService.call([order], shipping_region)
    end

    if items_by_one.first[:delivery_date] <= items_by_many.flatten.max_by { |k| k[:delivery_date] } [:delivery_date]
      return [items_by_one]
    end

    items_by_many
  end

  private

  def suppliers(scope)
    queries = super

    Stock.from("(#{queries[0].to_sql} UNION #{queries[1].to_sql}) as stocks")
  end

  def find_common_suppliers(scope)
    scope = scope.select(<<~SQL.squish
      *,
      dense_rank() OVER (
        PARTITION BY stocks.product_name
        ORDER BY stocks.supplier) AS number_items
    SQL
                        ).order(number_items: :desc)

    region = ActiveRecord::Base.connection.quote(shipping_region)

    scope = scope.order("(delivery_times ->> #{region})::Integer DESC")

    [scope[0]]
  end
end
