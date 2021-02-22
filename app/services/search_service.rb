# frozen_string_literal: true

class SearchService
  def call(items, shipping_region)
    items_by_one = FindItemsByOneSupplier.new.call(items, shipping_region) if items.count > 1
    items_by_many = FindItemsByManySupplier.new.call(items, shipping_region)

    # return items_by_many if send_by_one_supplier?(items_by_one, items_by_many)


    items_by_many
  end

  private

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
