# frozen_string_literal: true

class OrderPresenter
  def initialize(target)
    @target = target
  end

  attr_reader :target

  def call
    {
      delivery_date: Date.today + 2,
      shipments: items,
    }
  end
  
  def items
    target.map do |object|
      { supplier: object[:supplier],
        delivery_date: object[:delivery_times]["us"],
        count: object[:in_stock]
      }
    end    
  end
end
