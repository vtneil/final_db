-- FUNCTION 1
CREATE OR REPLACE FUNCTION get_property_rent_by_range(
    max_price DOUBLE PRECISION,
    min_price DOUBLE PRECISION
)
    RETURNS TABLE
            (
                property_id     UUID,
                price_per_month DOUBLE PRECISION
            )
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY
        SELECT property_listing_for_rent.property_id,
               property_listing_for_rent.price_per_month
        FROM property_listing_for_rent
        WHERE property_listing_for_rent.price_per_month BETWEEN min_price AND max_price
          AND property_listing_for_rent.is_occupied = FALSE;
END
$$;

-- FUNCTION 2
CREATE OR REPLACE FUNCTION search_property_by_keyword(
    keyword VARCHAR)
    RETURNS SETOF property_listing
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY
        SELECT *
        FROM property_listing
        WHERE LOWER(description) LIKE keyword
           OR residential_type LIKE keyword
           OR project_name LIKE keyword;
END
$$;

-- RUN FUNCTIONS

-- RUN FUNCTION 1
SELECT * FROM get_property_rent_by_range(3000, 0);

-- RUN FUNCTION 2
SELECT * FROM search_property_by_keyword('%sequi%')
