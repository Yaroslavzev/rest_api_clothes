# frozen_string_literal: true

class MultiSearchService < BaseSearchService
  def call
    items_by_many = items.map do |order|
      SingleSearchService.call([order], shipping_region)
    end

    items_by_one = select_suppliers(items_by_one_supplier)

    return items_by_one if send_by_one_supplier?(items_by_one, items_by_many)

    items_by_many
  end

  private

  def send_by_one_supplier?(items_by_one, items_by_many)
    biggest_delivery_date(items_by_one) <= biggest_delivery_date(items_by_many)
  end

  def biggest_delivery_date(array)
    array.flatten.max_by { |k| k[:delivery_date] }[:delivery_date]
  end
end
