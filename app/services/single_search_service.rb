# frozen_string_literal: true

class SingleSearchService < BaseSearchService
  def call
    # binding.pry
    results = Stock.yield_self(&method(:suppliers))
                   .yield_self(&method(:departure_country))
                   .yield_self(&method(:count_items))
                   .map{ |i| results(i) } # todo
    # binding.pry

    dd=select_suppliers(results)[0]
  end

  private

  def departure_country(scope)
    region = ActiveRecord::Base.connection.quote(shipping_region)

    # scope = scope.order("(delivery_times ->> #{region})::Integer ASC") #.first
    scope
  end

  def count_items(scope)
    region = ActiveRecord::Base.connection.quote(shipping_region)

    # TODO remove window function
    scope = scope.map do |query|
      query.select(<<~SQL.squish
      *,
      sum(in_stock) OVER (
        ORDER BY (delivery_times ->> #{region})::Integer ASC) AS sum_value
    SQL
  )
end
# binding.pry
  #.order(number_items: :desc)
    # binding.pry

    # scope = scope.order("(delivery_times ->> #{region})::Integer ASC") #.first
    scope
  end

  def select_suppliers(results)
    results.map do |raw|
      # binding.pry
      raw.each_with_object([{ordered_value: raw[0][:ordered_value]}]) do |object, array|
        # binding.pry
        # hash[:value] = 1
        tmp_hash = {}
        tmp_hash[:id]            = object[:id]
        tmp_hash[:product_name]  = object[:product_name]
        tmp_hash[:supplier]      = object[:supplier]
        tmp_hash[:delivery_date] = object[:delivery_date]

        if array.first[:ordered_value] - object[:in_stock] > 0
          tmp_hash[:value] = object[:in_stock]
          array.first[:ordered_value] = array.first[:ordered_value] - object[:in_stock]
        else
          tmp_hash[:value] = array.first[:ordered_value]
          array.first[:ordered_value] = array.first[:ordered_value] - object[:in_stock]
        end
        # tmp_hash[:product_name] = object[:product_name]

        array << tmp_hash
        # TODO #drop
        break array.drop(1) if array.first[:ordered_value] <= 0

      end
    end
  end
end
