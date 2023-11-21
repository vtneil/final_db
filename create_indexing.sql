CREATE INDEX idx_district ON property_listing(district);

CREATE INDEX idx_price_sell ON property_listing_for_sell(price);
CLUSTER property_listing_for_sell USING idx_price_sell;

CREATE INDEX idx_price_rent ON property_listing_for_rent(price_per_month);
CLUSTER property_listing_for_rent USING idx_price_rent;


