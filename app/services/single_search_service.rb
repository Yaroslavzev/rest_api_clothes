# frozen_string_literal: true

class SingleSearchService < BaseSearchService
  def call
    results = Stock.yield_self(&method(:suppliers))
                   .yield_self(&method(:departure_country))
                   .map { |i| results(i) } # todo

    select_suppliers(results)[0]
  end

  private

  def departure_country(scope)
    region = ActiveRecord::Base.connection.quote(shipping_region)

    scope.map do |query|
      query.order("(delivery_times ->> #{region})::Integer ASC")
    end
  end

  def select_suppliers(results)
    results.map do |raw|
      raw.each_with_object([{ ordered_value: raw[0][:ordered_value] }]) do |object, array|
        tmp_hash = tmp_hash(object)

        tmp_hash[:value] = if (array.first[:ordered_value] - object[:in_stock]).positive?
                             object[:in_stock]
                           else
                             array.first[:ordered_value]
                           end
        array.first[:ordered_value] = array.first[:ordered_value] - object[:in_stock]
        array << tmp_hash
        # TODO: #drop
        break array.drop(1) if array.first[:ordered_value] <= 0
      end
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
