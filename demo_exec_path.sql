EXPLAIN ANALYZE
SELECT PL.property_id, PL.residential_type, PLR.price_per_month
FROM property_listing PL,
     property_listing_for_rent PLR
WHERE PL.property_id = PLR.property_id
  AND PLR.is_occupied = False
  AND PLR.price_per_month < 7000;


EXPLAIN ANALYZE
SELECT PL.property_id, PL.residential_type, PLR.price_per_month
FROM property_listing PL
         JOIN property_listing_for_rent PLR
              ON PL.property_id = PLR.property_id
WHERE PLR.price_per_month < 7000
  AND PLR.is_occupied = False;