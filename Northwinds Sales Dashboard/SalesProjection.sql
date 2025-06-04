WITH yearly_sales AS (
  SELECT 
    CAST(YEAR(o.OrderDate) AS INT) AS OrderYear,
    ROUND(SUM(od.UnitPrice * od.Quantity), 0) AS ActualSales
  FROM orders o
  JOIN order_details od ON o.OrderID = od.OrderID
  WHERE 
    (:region_param = 'All' OR o.ShipRegion = :region_param)
    AND (:country_param = 'All' OR 
      CASE 
        WHEN o.ShipCountry = 'USA' THEN 'United States'
        WHEN o.ShipCountry = 'UK' THEN 'United Kingdom'
        ELSE o.ShipCountry
      END = :country_param)
  GROUP BY YEAR(o.OrderDate)
),

projected_sales AS (
  SELECT 
    OrderYear + 1 AS ProjectedYear,
    ROUND(ActualSales * 1.05, 0) AS ProjectedSales
  FROM yearly_sales
)

SELECT 
  CAST(OrderYear AS STRING) AS Year,
  ActualSales,
  NULL AS ProjectedSales
FROM yearly_sales

UNION ALL

SELECT 
  CAST(ProjectedYear AS STRING) AS Year,
  NULL AS ActualSales,
  ProjectedSales
FROM projected_sales

ORDER BY Year
