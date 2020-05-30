# frozen_string_literal: true

class MultiSearchService < BaseSearchService
  def call
    items_by_many = items.map do |order|
      SingleSearchService.call([order], shipping_region)
    end

    items_by_one = select_suppliers(items_by_one_supplier)

    return [items_by_one] if send_by_one_supplier?(items_by_one, items_by_many)

    items_by_many
  end

  private

  def items_by_one_supplier
    super
      .yield_self(&method(:find_common_suppliers))
      .map { |i| beatify(i) } # todo
  end

  def find_common_suppliers(scopes)
    scopes.map do |scope|
      scope = scope.select(<<~SQL.squish
        *,
        dense_rank() OVER (
          PARTITION BY stocks.product_name
          ORDER BY stocks.supplier) AS number_items
      SQL
                          ).order(number_items: :desc)

      scope.order("(delivery_times ->> #{region})::Integer DESC")
    end
  end

  def send_by_one_supplier?(items_by_one, items_by_many)
    items_by_one.flatten.first[:delivery_date] <= biggest_delivery_date(items_by_many)
  end

  def biggest_delivery_date(array)
    array.flatten.max_by { |k| k[:delivery_date] }[:delivery_date]
  end
end
