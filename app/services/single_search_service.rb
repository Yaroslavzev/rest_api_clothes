# frozen_string_literal: true

class SingleSearchService < BaseSearchService
  def call
    item_by_supplier = items_by_one_supplier
    select_suppliers(item_by_supplier)
  end
end
