# frozen_string_literal: true

class OrderPresenter
  attr_reader :target

  def initialize(target)
    @target = target
  end

  def call
    {
      delivery_date: biggest_delivery_date(target),
      shipments: suppliers
    }
  end

  def suppliers
    target.group_by { |h| h[:supplier] }.map do |key, array|
      { supplier: key,
        delivery_date: biggest_delivery_date(array),
        items: items(array) }
    end
  end

  def items(array)
    array.map do |hash|
      { title: hash[:product_name],
        count: hash[:value] }
    end
  end

  def biggest_delivery_date(array)
    array.max_by { |k| k[:delivery_date] }[:delivery_date].to_s
  end
end
# delivery_date: '2020-03-10',
# shipments: [
# {supplier: "Shirts4U", delivery_date: '2020-03-09' items: [
# {
# title: "tshirt",
# count: 10
# },
# {
# title: "hoodie",
# count: 5
# },
