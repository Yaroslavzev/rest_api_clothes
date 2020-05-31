# README


This repo is a REST API implementation of Moteefe's coding challenge based on Rails and Postgress.  
Rubocop and Rspec are used to code checking.

## Description
Project database is based on CSV form and description is here `db/schema.rb`  
Data for database are here `db/seeds.rb` and data have been changed.  
Sort algorithm is here `app/services/base_search_service.rb:57`  

The implementation implies that `get` request should be send to `/stocks` with parametres:
```json
 { order: {
  items: [
    {
      product_name: "pink_t-shirt",
      value: 2
    }
  ],
  shipping_region: "us"
} }
```
Also implies that `get` request has all fields filled in and suppliers have enough products for order.

## How to start
To start project locally needs setup database.  
Use request below to see how API works.  
```bash
curl -X GET -d "order[items][][product_name]=pink_t-shirt" -d "order[items][][value]=2" -d "order[shipping_region]=us" http://localhost:3000/stocks
```

## What to do
* add REST API documentations;
* divide database queries and sort algorithm;
* name refactoring;
* add incoming data validation and error processing;
* use docker.

