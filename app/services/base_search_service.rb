# frozen_string_literal: true

class BaseSearchService < ApplicationService
  attr_reader :items, :shipping_region

  def initialize(items, shipping_region)
    @items           = items
    @shipping_region = shipping_region
  end

  def call
    # Todo cheack
    raise NotImplementedError
  end

  private

  def items_by_one_supplier
    Stock.yield_self(&method(:suppliers))
  end

  def suppliers(scope)
    unioned_queries = items.map do |items|
      scope.where(product_name: items[:product_name])
    end.map(&:to_sql).join(" UNION ")

    [Stock.from("(#{unioned_queries}) as stocks")]
  end

  def beatify(results)
    results.map do |raw| # use pluck?
      raw.attributes.symbolize_keys.each_with_object({}) do |(k, v), hash|
        if v.is_a?(Hash)
          # TODO: remove
          hash[:ordered_value] = items.first[:value].to_i
          hash[:delivery_date] = Date.today + v[shipping_region] + 2
        else
          hash[k] = v
        end
      end
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

  def region
    ActiveRecord::Base.connection.quote(shipping_region)
  end
end
