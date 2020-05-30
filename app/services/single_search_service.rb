# frozen_string_literal: true

class SingleSearchService < BaseSearchService
  def call
    item_by_supplier = items_by_one_supplier

    select_suppliers(item_by_supplier)[0]
  end

  private

  def items_by_one_supplier
    super
      .yield_self(&method(:departure_country))
      .map { |i| beatify(i) }
  end

  def departure_country(scopes)
    scopes.map do |query|
      query.order("(delivery_times ->> #{region})::Integer ASC")
    end
  end
end
