# frozen_string_literal: true

require "spec_helper"

RSpec.describe API::V1::StocksController, type: :routing do
  describe "routing" do
    it "routes to #in_stock" do
      expect(post: "api/v1/in_stocks").to route_to("api/v1/stocks#in_stocks")
    end
  end
end
