# frozen_string_literal: true

class SearchService
  include Dry::Monads[:result, :do]
  include Dry::Monads::Do.for(:call)

  include AppImport[items_by_many_suppliers: "find_items_by_many_supplier"]


  def call(items, shipping_region)
    FindItemsByOneSupplier.new.call(items, shipping_region) if items.count > 1
    items_by_many = yield items_by_many_suppliers.call(items, shipping_region)

    # return items_by_many if send_by_one_supplier?(items_by_one, items_by_many)
    # binding.pry
    Success(items_by_many)
  end

  # def send_by_one_supplier?(items_by_one, items_by_many)
  #   return true if items_by_many.is_a?(NilClass) || items_by_one.is_a?(NilClass) || items_by_many.all?(&:nil?)
  #
  #   biggest_delivery_date(items_by_one) <= biggest_delivery_date(items_by_many)
  # end
  #
  # def biggest_delivery_date(array)
  #   array.flatten.max_by { |k| k[:delivery_date] }[:delivery_date]
  # end
end
