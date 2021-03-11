# README


This repo is an implementation for coding challenge by company providing Print-On-Demand based on Rails and Postgress.  
The task is to implement a REST API which gives out a number of days for delivery, 
the amounts of shipments and their details based on the list of items in the basket and the region where those items are supposed to be delivered.

## Implementation requirements

The outcome should be an object which should look like this:
```json
{
   "delivery_date":"2020-03-10",
   "shipments":[
      {
         "supplier":"Shirts4U",
         "delivery_date":"2020-03-09",
         "items":[
            {
               "title":"tshirt",
               "count":10
            },
            {
               "title":"hoodie",
               "count":5
            },
            {
               "supplier":"BesT-Shirts",
               "delivery_date":"2020-03-10",
               "items":[
                  {
                     "title":"mug",
                     "count":2
                  }
               ]
            }
         ]
      }
   ]
}
```

## Acceptance criteria


#### Scenario 1
Having a list of items containing product A with delivery time 3 days and product B with delivery time 1 day.
Then the delivery time is 3.
#### Scenario 2
Having product A from two suppliers A and B.
When supplier A delivers product A in 3 days and supplier B delivers product A in 2 days. Then delivery time for that product is 2 days.
####  Scenario 3
Having a t-shirt and hoodie in the basket.
When the t-shirt can be shipped from supplier A and B.
And hoodie can be shipped from supplier B and C.
Then deliver the t-shirt and hoodie from supplier B. edge case: It's faster to deliver it separately.
#### Scenario 4
Having 10 T-shirts in the basket and two suppliers A and B.
When there are only 6 T-shirts from supplier A and 7 T-shirts of supplier B on stock.
Then there would be two shipments one from supplier A with 6 T-shirts and second from supplier B.
edge case: split it into 3

## Remarks on implementation
#### General
Rubocop, Rspec and Undercover are used to code checking during CI.   
Scenario 1, 2 and 4 fully implemented and covered with tests(`spec/services/search_service_spec.rb`)   
Note about scenario 3: edge case based on comparing the maximum delivery 
time from one supplier and the maximum delivery time from different suppliers.  
Project database is based on CSV form(`db/seeds.rb`). Additional data were added.  

  
#### Input schema for endpoint
The implementation implies `post` request should be send to `api/v1/in_stocks` with parametres:
```json
{
    type: :object,
    properties: {
      order: {
        items: {
          type: Array,
          properties: {
            product_name: { type: :string },
            value: { type: :int }
          }
        },
        shipping_region: { type: :string }
      }
    },
    required: true
}
```
Each field must be filled and `value` must be more than `0`.


#### How to start
* Download repo;
* Add env file for test and development environment;
* Install gems: `bundle install`;
* Set up databases and do migrations;
* enjoy happy checking.

## What to do
* describe `how to start`;
* use docker: add monitoring, nginx;
* simplify database structure, add Factory and beatify rspec;

