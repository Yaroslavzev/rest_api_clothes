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
      binding.pry
      expect(response).to be_successful      
    end
  end
end

curl -X GET --header "Content-Type: application/json" -d "{\"order\":{\"items\":[{\"product_name\":\"pink_t-shirt\",\"value\":2}],\"shipping_region\":\"us\"}}" http://localhost:3000/index


curl -X GET http://localhost:3000/stocks


curl -X GET 'http://localhost:3000/stocks/index' -d "{\"order\":{\"items\":[{\"product_name\":\"pink_t-shirt\",\"value\":2}],\"shipping_region\":\"us\"}}"


curl -X GET \
  -H "Content-type: application/json" \
  -H "Accept: application/json" \
  -d '{"order\": {"items": [ { "product_name": "pink_t-shirt", "value": 2 } ], "shipping_region": "us"}}' \
  "http://localhost:3000/stocks/index"
  
  
  curl http://localhost:3000/stocks?order=
  
  {items: [{product_name: "pink_t-shirt", value: 2 }]}
  
  
        { order: {
          items: [ { product_name: "pink_t-shirt", value: 2 } ], shipping_region: "us"} }
          
          { order: { items: [ { product_name: "pink_t-shirt", value: 2 } ], shipping_region: "us"} }
          
          
  http://localhost:3000/stocks?order=items%3A%20%5B%20%7B%20product_name%3A%20%22pink_t-shirt%22%2C%20value%3A%202%20%7D%20%5D%2C%20shipping_region%3A%20%22us%22%7D
  
  
  
  
  curl -k --header "Content-Type: application/json" --request GET --data '{ order: { items: [ { product_name: "pink_t-shirt", value: 2 } ], shipping_region: "us"} }' http://localhost:3000/stocks
  
  curl http://localhost:3000/stocks -d"order=items&last_name=Wayne"
  
  
  
  
  
  -g --insecure
  
  curl -X GET -v -i -g --insecure 'http://localhost:3000/stocks?order=items%3A%20%5B%20%7B%20product_name%3A%20%22pink_t-shirt%22%2C%20value%3A%202%20%7D%20%5D%2C%20shipping_region%3A%20%22us%22%7D'
  
  curl http://localhost:3000/stocks/?formatjson={\"id\"}
  
  curl -X GET -d "order[items][product_name]=pink_t-shirt" -d "order[items][value]=2" -d "order[shipping_region]=us" http://localhost:3000/stocks
  
  curl -X GET -d "order[items][][product_name]=pink_t-shirt" -d "order[items][][value]=2" -d "order[shipping_region]=us" http://localhost:3000/stocks
  curl -X GET -d  '{ "name": "Darth" }' http://localhost:3000/stocks
  
 
  
        
        