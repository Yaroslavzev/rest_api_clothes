# frozen_string_literal: true

class FindItemsByManySupplier
  include Dry::Monads[:result, :do]
  include Dry::Monads::Do.for(:call)

  def call(items, shipping_region)
    results = items.map do |item|
      result = yield find_items_by_one_supplier(item, shipping_region)

      yield select_suppliers(result, item)
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

  # TODO: move to concern
  # rubocop:disable Metrics/AbcSize
  def select_suppliers(results, item)
    # selected_suppliers = OpenStruct.new( supplier: )
    selected_suppliers = []

    results.each_with_object({ ordered_value: item[:value], supplier_count: results.size }) do |object, ordered_values|
      ordered_values[:ordered_value] = ordered_values[:ordered_value] - object[:in_stock]

      value = ordered_values[:ordered_value] >= 0 ? object[:in_stock] : ordered_values[:ordered_value] + object[:in_stock]
      selected_suppliers << serialised_hash(object, value)

      return Failure[:doesnt_have_enough_in_stock, product_name: object.product_name] if not_enough_in_stock?(object, ordered_values)
      break Success(selected_suppliers) if stop_selection?(ordered_values[:ordered_value]) # TODO: add not enougth in_stock and remove last
    end
  end
  # rubocop:enable Metrics/AbcSize

  # TODO: add serializer
  def serialised_hash(object, value)
    {
      product_name: object.product_name,
      supplier: object.supplier,
      delivery_time: object.delivery_time,
      ordered_values: value
    }
  end

  def stop_selection?(ordered_value)
    ordered_value <= 0
  end

  def not_enough_in_stock?(object, ordered_values)
    ordered_values[:supplier_count] == object.supplier_number && ordered_values[:ordered_value].positive?
  end
end
