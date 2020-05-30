# frozen_string_literal: true

class BaseSearchService < ApplicationService
  attr_reader :items, :shipping_region

  def initialize(items, shipping_region)
    @items           = items
    @shipping_region = shipping_region
  end

  def suppliers(scope)
    # binding.pry
    ee = items.map do |items|
      # binding.pry
      scope.where(product_name: items[:product_name])
      # .where(':value <= in_stock', value: items[:value])
    end
    # binding.pry
    ee
  end

  def results(results)
    # binding.pry
    ee = results.map do |raw|
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
    binding.pry
    ee
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
end