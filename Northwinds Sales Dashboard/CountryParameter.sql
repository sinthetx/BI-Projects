SELECT DISTINCT
  CASE
    WHEN ShipCountry = 'USA' THEN 'United States'
    WHEN ShipCountry = 'UK' THEN 'United Kingdom'
    ELSE ShipCountry
  END AS Country
FROM orders
WHERE (:region_param = 'All' OR ShipRegion = :region_param)
ORDER BY Country
