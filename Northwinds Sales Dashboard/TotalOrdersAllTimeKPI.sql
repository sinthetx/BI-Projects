SELECT 
  COUNT(DISTINCT o.OrderID) AS total_orders
FROM orders o
WHERE 
  (:region_param = 'All' OR o.ShipRegion = :region_param)
  AND (:country_param = 'All' OR 
       CASE 
         WHEN o.ShipCountry = 'USA' THEN 'United States'
         WHEN o.ShipCountry = 'UK' THEN 'United Kingdom'
         ELSE o.ShipCountry
       END = :country_param)
