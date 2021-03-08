# frozen_string_literal: true

class FindItemsByOneSupplier
  def call(items, shipping_region)
    scope = collect_suppliers(items, shipping_region)
    scope
  end

  private

  # rubocop:disable Metrics/MethodLength
  def collect_suppliers(items, shipping_region)
    region = ActiveRecord::Base.connection.quote(shipping_region)

    product_name_array = items.map{ |item| "'#{item[:product_name]}'"}.join(", ")

    query = <<~SQL.squish
      WITH aggregated_suppliers AS (
        SELECT
          ARRAY_AGG(product_name) AS all_products,
          max((delivery_times ->> #{region})::Integer) AS max_delivery_time,
          supplier
        FROM
          stocks
        GROUP BY
          supplier
      )
      SELECT
        supplier
      FROM
        aggregated_suppliers
      WHERE
        all_products::varchar [] @> ARRAY [#{product_name_array}]::varchar [];
    SQL
    suppliers = ActiveRecord::Base.connection.execute(query)

    Stock.where(product_name: items.pluck(:product_name)).where(suppliers[0])
  end
  # rubocop:enable Metrics/MethodLength
end
