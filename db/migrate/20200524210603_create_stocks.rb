class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.string  :product_name
      t.string  :supplier
      t.jsonb   :delivery_times
      t.integer :in_stock
    end
  end
end
