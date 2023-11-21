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
    IF EXISTS (SELECT 1
               FROM "rent"
                        JOIN "transaction" ON "rent"."transaction_id" = "transaction"."transaction_id"
               WHERE "rent"."property_id" = NEW.property_id
                 AND "transaction"."is_released" = FALSE
                 AND "transaction"."is_canceled" = FALSE) THEN
        -- If the condition is met, raise an exception to prevent the price change
        RAISE EXCEPTION 'Price change not allowed for property with ongoing transaction';
    END IF;

    RETURN NEW;
END
$$;

-- Create the trigger
CREATE TRIGGER prevent_price_change_trigger
    BEFORE UPDATE
    ON "property_listing_for_rent"
    FOR EACH ROW
EXECUTE FUNCTION prevent_price_change();
