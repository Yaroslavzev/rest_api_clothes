# frozen_string_literal: true

class SearchService
  include Dry::Monads[:result, :do]
  include Dry::Monads::Do.for(:call)

  include AppImport[items_by_many_suppliers: "search.find_items_by_many_supplier",
                    find_items_by_one_supplier: "search.find_items_by_one_supplier"
          ]

  def call(items, shipping_region)
    items_by_one = find_items_by_one_supplier.call(items, shipping_region) if items.count > 1
    items_by_many = items_by_many_suppliers.call(items, shipping_region)

    result = yield resolve_supplier(items_by_one, items_by_many, items)

    Success(result)
  end

  def resolve_supplier(items_by_one, items_by_many, items)
    return items_by_many if items_by_one.nil?
    # maybe add special error type
    return Failure[:not_found, product_name: [items.pluck(:product_name)]] if items_by_one.failure? && items_by_many.failure?
    return items_by_many if items_by_one.failure?
    return items_by_one if items_by_many.failure?

    by_one = items_by_one.value!.flatten.max_by { |k| k[:delivery_time] }[:delivery_time]
    by_many = items_by_many.value!.flatten.max_by { |k| k[:delivery_time] }[:delivery_time]
    by_one > by_many ? items_by_many : items_by_one
  end
end
