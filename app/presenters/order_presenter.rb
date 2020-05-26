# frozen_string_literal: true

class OrderPresenter
  def initialize(target)
    @target = target
  end

  attr_reader :target

  def call
    binding.pry
    {
      delivery_date: Date.today + target.delivery_times["us"] + 2,
      # shipments: items,
    }
  end
  
  def items
    
  end
end