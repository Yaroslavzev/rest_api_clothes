# frozen_string_literal: true

class ResolverService < ApplicationService
  attr_reader :search

  def initialize(search)
    @search = HashWithIndifferentAccess.new(search)
  end

  def call
    if search[:items].count == 1
      SingleSearchService.call(search[:items], search[:shipping_region])
    else
      MultiSearchService.call(search[:items], search[:shipping_region])
    end
  end
end
