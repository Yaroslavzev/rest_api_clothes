# frozen_string_literal: true

require "rails_helper"

RSpec.describe StocksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/stocks").to route_to("stocks#index")
    end
  end
end
