# frozen_string_literal: true

module Search
  class FindItemsByOneSupplier
    include Dry::Monads[:result, :do]
    include Dry::Monads::Do.for(:call)

    def call(items, shipping_region)
      results = collect_suppliers(items, shipping_region)
      # use? (results + items).group_by { |person| person[:product_name] }
      results = results.each_with_object([]) do |x, object|
        items.each do |item|
          if item[:product_name] == x.product_name
            result = yield Search::SelectSuppliers.new.call(result: [x], item: item)
            object << result
          end
        end
      end

      Success(results)
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
      supplier = ActiveRecord::Base.connection.execute(query)

      Stock.where(product_name: items.pluck(:product_name)).where(supplier[0]).select(<<~SQL.squish
      *, (delivery_times ->> #{region})::Integer AS delivery_time,
      row_number() OVER (
        PARTITION BY stocks.product_name ORDER BY (delivery_times ->> #{region})::Integer) AS supplier_number
      SQL
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
