# frozen_string_literal: true

module Search
  class FindItemsByManySupplier
    include Dry::Monads[:result, :do]
    include Dry::Monads::Do.for(:call)

    def call(items, shipping_region)
      results = items.map do |item|
        result = yield find_items_by_one_supplier(item, shipping_region)

        yield Search::SelectSuppliers.new.call(result: result, item: item)
      end

      Success(results)
    end

    private

    def find_items_by_one_supplier(item, shipping_region)
      region = ActiveRecord::Base.connection.quote(shipping_region)
      scope = Stock.where(product_name: item[:product_name])

      return Failure[:not_found, product_name: item[:product_name]] unless scope.exists?

      scope = scope.select(<<~SQL.squish
        *, (delivery_times ->> #{region})::Integer AS delivery_time,
        row_number() OVER (
          PARTITION BY stocks.product_name ORDER BY (delivery_times ->> #{region})::Integer) AS supplier_number
      SQL
                          )
      Success(scope)
    end
  end
end
