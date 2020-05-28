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
    results.map do |raw|
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
end
