# frozen_string_literal: true

require "spec_helper"

RSpec.describe StocksController, type: :routing do
  describe "routing" do
    it "routes to #in_stock" do
      expect(post: "/in_stocks").to route_to("stocks#in_stocks")
    end
  end
end
