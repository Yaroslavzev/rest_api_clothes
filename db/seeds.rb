# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

sql_query = "INSERT INTO stocks (product_name,supplier,delivery_times,in_stock ) VALUES
            ('black_mug'    , 'Shirts4U'         , '{ \"eu\": 2, \"us\": 6, \"uk\": 2}', 3 ),
            ('blue_t-shirt' , 'Best Tshirts'     , '{ \"eu\": 1, \"us\": 5, \"uk\": 2}', 10),
            ('white_mug'    , 'Shirts Unlimited' , '{ \"eu\": 1, \"us\": 8, \"uk\": 2}', 3 ),
            ('black_mug'    , 'Shirts Unlimited' , '{ \"eu\": 1, \"us\": 7, \"uk\": 2}', 4 ),
            ('pink_t-shirt' , 'Shirts4U'         , '{ \"eu\": 4, \"us\": 6, \"uk\": 2}', 8 ),
            ('pink_t-shirt' , 'Shirts4U and me'  , '{ \"eu\": 4, \"us\": 6, \"uk\": 2}', 8 ),
            ('pink_t-shirt' , 'Best Tshirts'     , '{ \"eu\": 2, \"us\": 3, \"uk\": 2}', 2 ) "

ActiveRecord::Base.connection.execute(sql_query)
