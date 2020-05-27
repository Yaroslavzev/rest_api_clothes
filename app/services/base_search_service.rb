# frozen_string_literal: true

class BaseSearchService < ApplicationService
  attr_reader :items, :shipping_region

  def initialize(items, shipping_region)
    @items           = items
    @shipping_region = shipping_region
  end

  def suppliers(scope)
    items.map do |items|
      scope.where(product_name: items[:product_name])
           .where(':value <= in_stock', value: items[:value])
    end
  end

  def results(results)
    results.attributes.symbolize_keys.each_with_object({}) do |(k, v), hash|
      if v.is_a?(Hash)
        # TODO: remove
        hash[:value] = items.first[:value]
        hash[:delivery_date] = Date.today + v[shipping_region] + 2
      else
        hash[k] = v
      end
    end
  end
end
