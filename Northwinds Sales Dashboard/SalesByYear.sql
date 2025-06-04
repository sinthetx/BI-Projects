SELECT 
  CAST(YEAR(o.OrderDate) AS STRING) AS OrderYear,
  ROUND(SUM(od.UnitPrice * od.Quantity), 0) AS `Total Sales`
FROM orders o
JOIN order_details od ON o.OrderID = od.OrderID
WHERE 
  (:region_param = 'All' OR o.ShipRegion = :region_param)
  AND (
    :country_param = 'All' OR 
    CASE 
      WHEN o.ShipCountry = 'USA' THEN 'United States'
      WHEN o.ShipCountry = 'UK' THEN 'United Kingdom'
      ELSE o.ShipCountry
    END = :country_param
  )
GROUP BY YEAR(o.OrderDate)
ORDER BY OrderYear
