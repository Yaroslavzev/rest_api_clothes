# frozen_string_literal: true
module Search
  class SelectSuppliers
    include Dry::Monads[:result, :do]
    include Dry::Monads::Do.for(:call)

    def call(result:, item:)
      select_suppliers(result, item)
    end

    # rubocop:disable Metrics/AbcSize
    def select_suppliers(result, item)
      selected_suppliers = []

      result.each_with_object({ ordered_value: item[:value], supplier_count: result.size }) do |object, ordered_values|
        ordered_values[:ordered_value] = ordered_values[:ordered_value] - object[:in_stock]

        value = value_from_supplier(ordered_values[:ordered_value], object[:in_stock])
        selected_suppliers << FoundedItemsSerializer.new(object, value: value).build_schema

        return Failure[:doesnt_have_enough_in_stock, product_name: object.product_name] if not_enough_in_stock?(object, ordered_values)
        break Success(selected_suppliers) if stop_selection?(ordered_values[:ordered_value])
      end
    end
    # rubocop:enable Metrics/AbcSize

    def value_from_supplier(ordered_value, in_stock)
      ordered_value >= 0 ? in_stock : ordered_value + in_stock
    end

    def stop_selection?(ordered_value)
      ordered_value <= 0
    end

    def not_enough_in_stock?(object, ordered_values)
      ordered_values[:supplier_count] == object.supplier_number && ordered_values[:ordered_value].positive?
    end
  end
end
