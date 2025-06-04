SELECT 
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
WHERE 
  (:region_param = 'All' OR o.ShipRegion IN (:region_param))
  AND (
    :country_param = 'All' OR
    CASE 
      WHEN o.ShipCountry = 'USA' THEN 'United States'
      WHEN o.ShipCountry = 'UK' THEN 'United Kingdom'
      ELSE o.ShipCountry
    END = :country_param
  )
  AND (:year_param = 'All' OR CAST(YEAR(o.OrderDate) AS STRING) = :year_param)
GROUP BY 
  CASE 
    WHEN o.ShipCountry = 'USA' THEN 'United States'
    WHEN o.ShipCountry = 'UK' THEN 'United Kingdom'
    ELSE o.ShipCountry
  END,
  o.ShipRegion,
  YEAR(o.OrderDate)
ORDER BY `Total Sales` DESC
