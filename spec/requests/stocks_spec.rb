# frozen_string_literal: true

require "spec_helper"

RSpec.describe "/stocks" do
  describe "GET /index" do
    let(:params) do
      { params: { order: {
        items: [
          {
            product_name: "pink_t-shirt",
            value: 2
          }
        ],
        shipping_region: "us"
      } } }
    end

    it "returns a successful response" do
      get stocks_path, params

      expect(response).to be_successful      
    end
  end
end

 
  
        
        