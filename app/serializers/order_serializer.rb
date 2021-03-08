# frozen_string_literal: true

class OrderSerializer
  include Dry::Monads[:result, :do]
  include Dry::Monads::Do.for(:call)

  # TODO: thing about serializer with gem
  def call(target:)
    result = {
      delivery_date: biggest_delivery_date(target),
      shipments: suppliers(target)
    }

    Success(result)
  end

  private

  def suppliers(target)
    target.group_by { |h| h[:supplier] }.map do |key, array|
      { supplier: key,
        delivery_date: biggest_delivery_date(array),
        items: items(array) }
    end
  end

  def items(array)
    array.map do |hash|
      { title: hash[:product_name],
        count: hash[:ordered_values] }
    end
  end

  def biggest_delivery_date(array)
    delivery_date = Date.today + array.max_by { |k| k[:delivery_time] }[:delivery_time] + 2
    delivery_date.to_date.strftime("%Y-%m-%d")
  end
end
