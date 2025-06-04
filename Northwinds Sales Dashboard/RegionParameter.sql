SELECT DISTINCT
  CASE
    WHEN ShipRegion IS NULL THEN 'Unknown'
    ELSE ShipRegion
  END AS region_param
FROM orders
UNION
SELECT 'All'
