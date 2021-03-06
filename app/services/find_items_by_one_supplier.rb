
# frozen_string_literal: true

class FindItemsByOneSupplier
  def call(items, shipping_region)

    scope = collect_suppliers(items, shipping_region)
    scope = find_common_suppliers(scope, shipping_region)
    # binding.pry
    results = beatify(scope, items, shipping_region)
    # binding.pry
    select_suppliers(results, items)
  end

  private

  def collect_suppliers(items, shipping_region)
    region = ActiveRecord::Base.connection.quote(shipping_region)

    query =<<~SQL.squish
        WITH aggregated_suppliers AS (
                                         SELECT
          ARRAY_AGG(product_name) as all_products,
                                     max((delivery_times ->> #{region})::Integer) as max_delivery_time,
                                                                                supplier
          FROM
          stocks
          GROUP BY
          supplier)
          SELECT supplier
          FROM aggregated_suppliers
          WHERE
          all_products::varchar[] @> ARRAY['pink_t-shirt', 'black_mug']::varchar[];
    SQL
    suppliers = ActiveRecord::Base.connection.execute(query)

    Stock.where(product_name: items.pluck(:product_name)).where(suppliers[0])
  end

  def find_common_suppliers(scope, shipping_region)
    region = ActiveRecord::Base.connection.quote(shipping_region)

    scope = scope.select(<<~SQL.squish
      *,
      dense_rank() OVER (
        PARTITION BY stocks.supplier
        ORDER BY stocks.product_name) AS supplier_rank,
        ((stocks.delivery_times ->> #{region})::Integer) as delivery_duration
    SQL
    ).order(supplier_rank: :desc)
    scope.order(Arel.sql("(delivery_times ->> #{region})::Integer ASC"))
  end

  def beatify(results, items, shipping_region)
    results.map do |raw| # use pluck?
    raw.attributes.symbolize_keys.each_with_object({}) do |(k, v), hash|
      if v.is_a?(Hash)
        hash[:ordered_value] = items.first[:value].to_i
        hash[:delivery_date] = Date.today + v[shipping_region] + 2
      else
        hash[k] = v
      end
    end
    end
  end

  def select_suppliers(results, items)
    items.map do |item|
      result = results.flatten.select { |x| x[:product_name] == item[:product_name] }

      result.each_with_object([{ ordered_value: item[:value] }]) do |object, array|
        tmp_hash = tmp_hash(object)
        tmp_hash[:value] = if (array.first[:ordered_value] - object[:in_stock]).positive?
                             object[:in_stock]
                           else
                             array.first[:ordered_value]
                           end
        array.first[:ordered_value] = array.first[:ordered_value] - object[:in_stock]
        array << tmp_hash

        break array.drop(1) if array.first[:ordered_value] <= 0
      end
    end
  end

  def tmp_hash(object)
    {
        id: object[:id],
        product_name: object[:product_name],
        supplier: object[:supplier],
        delivery_date: object[:delivery_date]
    }
  end

  def send_by_one_supplier?(items_by_one, items_by_many)
    return true if items_by_many.is_a?(NilClass) || items_by_many.all?(&:nil?)

    biggest_delivery_date(items_by_one) <= biggest_delivery_date(items_by_many)
  end

  def biggest_delivery_date(array)
    array.flatten.max_by { |k| k[:delivery_date] }[:delivery_date]
  end
end
