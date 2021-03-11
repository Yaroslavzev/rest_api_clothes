# frozen_string_literal: true

class FoundedItemsSerializer < Surrealist::Serializer
  json_schema do
    {
        product_name: String,
        supplier: String,
        delivery_time: Integer,
        ordered_values: Integer
    }
  end

  def product_name
    object.product_name
  end

  def supplier
    object.supplier
  end

  def delivery_time
    object.delivery_time
  end

  def ordered_values
    context[:value]
  end

end
