# frozen_string_literal: true

class SingleSearchService < BaseSearchService
  def call
    item_by_supplier = items_by_one

    select_suppliers(item_by_supplier)[0]
  end

  private

  def items_by_one
    Stock.yield_self(&method(:suppliers))
         .yield_self(&method(:departure_country))
         .map { |i| results(i) } # todo
         # .map{ |i| results(i) } # todo
         # change inteface in find_common_suppliers
  end

  def departure_country(scope)
    region = ActiveRecord::Base.connection.quote(shipping_region)

    scope.map do |query|
      query.order("(delivery_times ->> #{region})::Integer ASC")
    end
  end



  def tmp_hash(object)
    {
      id: object[:id],
      product_name: object[:product_name],
      supplier: object[:supplier],
      delivery_date: object[:delivery_date]
    }
  end
end
