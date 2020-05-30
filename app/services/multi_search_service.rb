# frozen_string_literal: true

class MultiSearchService < BaseSearchService
  def call
    items_by_one = Stock.yield_self(&method(:suppliers))
                        .yield_self(&method(:find_common_suppliers))
                        .map{ |i| results(i) } # todo
    # change inteface in find_common_suppliers
    # items_by_one = results(items_by_one)

    items_by_many = items.map do |order|
      SingleSearchService.call([order], shipping_region)
    end

    binding.pry
    return [items_by_one] if items_by_one.first[:delivery_date] <= biggest_delivery_date(items_by_many)

    items_by_many
  end

  private

  # def items_by_one
  #
  # end

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

    [scope]
  end

  def biggest_delivery_date(array)
    array.flatten.max_by { |k| k[:delivery_date] }[:delivery_date]
  end
end
