# frozen_string_literal: true

class OrderPresenter
  include Dry::Monads[:result, :do]
  include Dry::Monads::Do.for(:call)
  # attr_reader :target

  # def initialize(target)
  #   @target = target
  # end

  def call(target:)
    # TODO: thing about serializer
    # kek = ShipmentSerializer.new(target).build_schema

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
