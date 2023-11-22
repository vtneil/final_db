-- TRIGGER 1
CREATE OR REPLACE FUNCTION hide_property_after_transaction()
    RETURNS TRIGGER
    language plpgsql
AS
$$
BEGIN
    -- Check if isReleased is set to TRUE
    IF NEW.is_released = TRUE THEN
        -- Set isOccupied in property_listing to TRUE
        UPDATE "property_listing_for_rent"
        SET is_occupied = TRUE
        WHERE property_id = (SELECT property_id
                             FROM "rent"
                             WHERE transaction_id = NEW.transaction_id);

        UPDATE "property_listing_for_sell"
        SET is_sold = TRUE
        WHERE property_id = (SELECT property_id
                             FROM "sell"
                             WHERE transaction_id = NEW.transaction_id);

    END IF;

    RETURN NEW;
END
$$;

-- Create the trigger
CREATE TRIGGER release_transaction_trigger
    AFTER UPDATE
    ON "transaction"
    FOR EACH ROW
EXECUTE PROCEDURE hide_property_after_transaction();

-- TRIGGER 2
CREATE OR REPLACE FUNCTION prevent_price_change()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
BEGIN
    -- Check if there is a transaction for the property with isReleased = false and isCanceled = false
    IF TG_OP = 'UPDATE' AND NEW.price_per_month IS DISTINCT FROM OLD.price_per_month AND EXISTS (SELECT 1
                                                                                                 FROM "rent"
                                                                                                          JOIN "transaction"
                                                                                                               ON "rent"."transaction_id" = "transaction"."transaction_id"
                                                                                                 WHERE "rent"."property_id" = NEW.property_id
                                                                                                   AND "transaction"."is_released" = FALSE
                                                                                                   AND "transaction"."is_canceled" = FALSE) THEN
        -- If the condition is met, raise an exception to prevent the price change
        RAISE EXCEPTION 'Price change not allowed for property with ongoing transaction';
    END IF;

    RETURN NEW;
END;
$$;

-- Create the trigger
CREATE TRIGGER prevent_price_change_trigger
    BEFORE UPDATE
    ON "property_listing_for_rent"
    FOR EACH ROW
EXECUTE FUNCTION prevent_price_change();

-- Demo
-- TRIGGER 1
-- Find satisfy transaction to test --
SELECT transaction_id
FROM "rent"
         NATURAL JOIN "transaction"
         NATURAL JOIN property_listing_for_rent
WHERE is_occupied = false
  AND is_canceled = false
  AND is_released = false;

-- Show data (May change transation_id, choose transaction_id that is_occupied = false, is_released = false, is_cancel = false)
SELECT property_id, is_occupied, transaction_id, is_released
FROM "rent"
         NATURAL JOIN "property_listing_for_rent"
         NATURAL JOIN "transaction"
WHERE transaction_id = '085e56a8-7247-4e00-8dab-8ae34c042933';

-- Update is_released to true
UPDATE "transaction"
SET is_released = true
WHERE transaction_id = '085e56a8-7247-4e00-8dab-8ae34c042933';

-- Show data again (is_occupied should change to true)
SELECT property_id, is_occupied, transaction_id, is_released
FROM "rent"
         NATURAL JOIN "property_listing_for_rent"
         NATURAL JOIN "transaction"
WHERE transaction_id = '085e56a8-7247-4e00-8dab-8ae34c042933';


-- TRIGGER 2
-- may change transaction_id, property_id for test (choose transaction that is_released and is_canceled is false)
-- find transation_id, property_id that satisfy to test
SELECT transaction_id, property_id
FROM "rent"
         NATURAL JOIN "transaction"
WHERE is_released = false
  AND is_canceled = false;

--- Show is_released, is_canceled are false
SELECT property_id, transaction_id, is_released, is_canceled
FROM "rent"
         NATURAL JOIN "transaction"
WHERE transaction_id = 'fe79ec0d-2b60-4c5a-bdfc-3c1abc5a86d8';

--- Show current price_per_month of above
SELECT property_id, price_per_month
FROM "property_listing_for_rent"
WHERE property_id = 'e94cc047-a9d8-4c8a-858e-7e880c73a20b';

--- Set is_released, is_canceled to false (if not)
-- UPDATE "transaction"
-- SET is_released = false, is_canceled = false
-- WHERE transaction_id = '57ccbfcc-33e3-4b4f-9b4f-4f22dda0796a';

--- Test trigger (Should throw error)
UPDATE "property_listing_for_rent"
SET price_per_month = 3000
WHERE property_id = 'e94cc047-a9d8-4c8a-858e-7e880c73a20b';

--- Show price_per_month (Value should not change)
SELECT property_id, price_per_month
FROM "property_listing_for_rent"
WHERE property_id = 'e94cc047-a9d8-4c8a-858e-7e880c73a20b';
