-- PROCEDURE 1
drop procedure;
CREATE OR REPLACE PROCEDURE init_transaction(
    prpty_id UUID,
    dwllr_email VARCHAR(319),
    rent_start_date TIMESTAMP,
    tx_id UUID,
    pay_time_stamp TIMESTAMP,
    payment_method CHAR(50),
    amt FLOAT(24)
)
    language plpgsql
AS
$$
BEGIN
    INSERT INTO transaction
    VALUES (tx_id, pay_time_stamp, payment_method, FALSE, FALSE, amt);

    INSERT INTO rent
    VALUES (prpty_id, dwllr_email, tx_id, rent_start_date);
END
$$;

-- PROCEDURE 2
CREATE OR REPLACE PROCEDURE remove_expired_ad()
AS
$$
DECLARE
    cursor_deleted_rows CURSOR FOR
        SELECT *
        FROM advertisement
        WHERE now() > end_date;
    deleted_row advertisement%ROWTYPE;
BEGIN
    OPEN cursor_deleted_rows;

    LOOP
        FETCH cursor_deleted_rows INTO deleted_row;
        EXIT WHEN NOT FOUND;

        -- Process each deleted row as needed
        RAISE NOTICE 'Deleted row: %', deleted_row;
    END LOOP;

    CLOSE cursor_deleted_rows;

    DELETE
    FROM advertisement
    WHERE now() > end_date;
END
$$ LANGUAGE plpgsql;

-- Demo

-- Procedure 1
SELECT *
FROM advertisement
ORDER BY end_date DESC;

CALL remove_expired_ad();

SELECT *
FROM advertisement
ORDER BY end_date DESC;

-- Procedure 2
SELECT *
FROM transaction
ORDER BY timestamp DESC;

CALL init_transaction(
        '41a448d4-43ec-411a-a692-2d68e06e0282',
        'James.Merlin@vt.in.th',
        '2024-12-18 20:37:36.000000',
        '41a448d4-43ec-411a-a692-2d68e06e0282',
        '2023-12-18 23:00:00',
        'Credit Card',
        99000
     );

SELECT *
FROM transaction
ORDER BY timestamp DESC;