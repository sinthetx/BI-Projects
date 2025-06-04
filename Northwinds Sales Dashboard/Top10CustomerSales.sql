-- Step 1: Base aggregated sales
WITH base_data AS (
  SELECT
    o.ShipName AS `Company Name`,
    CASE 
      WHEN o.ShipCountry = 'USA' THEN 'United States'
      WHEN o.ShipCountry = 'UK' THEN 'United Kingdom'
      ELSE o.ShipCountry
    END AS Country,
    o.ShipRegion AS Region,
    CAST(YEAR(o.OrderDate) AS STRING) AS OrderYear,
    ROUND(SUM(od.UnitPrice * od.Quantity), 0) AS `Total Sales`
  FROM orders o
  JOIN order_details od ON o.OrderID = od.OrderID
  GROUP BY o.ShipName, o.ShipCountry, o.ShipRegion, YEAR(o.OrderDate)
),

-- Step 2: Apply dynamic filters
filtered_data AS (
  SELECT *
  FROM base_data
  WHERE 
    (:region_param = 'All' OR Region = :region_param)
    AND (:country_param = 'All' OR Country = :country_param)
    AND (:year_param = 'All' OR OrderYear = :year_param)
),

-- Step 3: Apply rank after filtering
ranked_data AS (
  SELECT *,
    RANK() OVER (ORDER BY `Total Sales` DESC) AS rank_in_filtered
  FROM filtered_data
)

-- Step 4: Only return top 10
SELECT *
FROM ranked_data
WHERE rank_in_filtered <= 10
