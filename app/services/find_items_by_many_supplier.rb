
# frozen_string_literal: true

class FindItemsByManySupplier
  def call(items, shipping_region)

    results = items.map do |item|
      result = find_items_by_one_supplier(item, shipping_region)

      select_suppliers(result, item)
    end

    results
  end

  private

  def find_items_by_one_supplier(item, shipping_region)
    scope = collect_suppliers(item, shipping_region)
    scope = find_common_suppliers(scope, shipping_region)
    scope
  end

  def collect_suppliers(item, shipping_region)
    region = ActiveRecord::Base.connection.quote(shipping_region)

    # TODO: revome selected fields
    Stock.where(product_name: item[:product_name])
        .select(<<~SQL.squish
                    *,
                    (stocks.in_stock - #{item[:value]}) as diff,
                    (#{item[:value]}) as ordered_value,
                    ((stocks.delivery_times ->> #{region})::Integer) as delivery_date
    SQL
    )
  end

  def find_common_suppliers(scope, shipping_region)
    region = ActiveRecord::Base.connection.quote(shipping_region)

    scope = scope.select(Arel.sql("(delivery_times ->> #{region})::Integer AS delivery_time"))
                 .order(:delivery_time)

    scope
  end

  def select_suppliers(results, item) # TODO: move to concern
    result = results
    # selected_suppliers = OpenStruct.new( supplier: )
    selected_suppliers = []

    result.each_with_object({ ordered_value: item[:value] }) do |object, ordered_values|

      ordered_values[:ordered_value] = ordered_values[:ordered_value] - object[:in_stock]

      value = ordered_values[:ordered_value] >= 0 ? object[:in_stock] : ordered_values[:ordered_value] + object[:in_stock]

      kek = { product_name: object.product_name,
              supplier: object.supplier,
              delivery_time: object.delivery_time,
              ordered_values: value

      }
      selected_suppliers << kek

      break selected_suppliers if ordered_values[:ordered_value] <= 0 # TODO: add not enougth in_stock and remove last
    end
  end
end

