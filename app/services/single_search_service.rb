# frozen_string_literal: true

class SingleSearchService < BaseSearchService
  def call
    # binding.pry
    results = Stock.yield_self(&method(:suppliers))
                   .yield_self(&method(:departure_country))

    results(results)
  end

  private

  def suppliers(scope)
    super[0]
  end

  def departure_country(scope)
    region = ActiveRecord::Base.connection.quote(shipping_region)

    scope = scope.order("(delivery_times ->> #{region})::Integer ASC").first
    scope
  end
end
