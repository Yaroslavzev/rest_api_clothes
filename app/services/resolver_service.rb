# frozen_string_literal: true

class ResolverService < ApplicationService
  attr_reader :search
  def initialize(search)
    @search = search
  end

  def call
    if search[:items].count == 1
      SingleSearchService.call(search)
    else 
      MultiSearchService.call(search)
    end
  end
end
