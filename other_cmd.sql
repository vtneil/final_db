-- Insert
-- Insert a new admin if they don't exist already
INSERT INTO admin (admin_id, admin_fname, admin_lname, admin_phone)
SELECT 'be4fb0db-9e5f-46f9-a82f-067d7a08a77b', 'John2', 'Doe2', '+1234567890'
WHERE NOT EXISTS (SELECT 1
                  FROM admin
                  WHERE admin_phone = '+1234567890');

-- Insert a new advertisement referencing the newly inserted admin
INSERT INTO advertisement (ad_id, start_date, company_id, admin_id)
VALUES ('1c2d06ec-9746-4461-b833-dfe143d322b4', CURRENT_TIMESTAMP, 'fd776b35-6e62-47ec-9f5d-c016ae8c9073', 'be4fb0db-9e5f-46f9-a82f-067d7a08a77a');


-- Update
UPDATE property_review
    SET score = 99
WHERE
    property_id = '1c2d06ec-9746-4461-b833-dfe143d322b4';

-- Delete
-- Delete property listing only if there are no appointments and images referencing it
DELETE
FROM property_listing
WHERE property_id = 'be4fb0db-9e5f-46f9-a82f-067d7a08a77a'
  AND NOT EXISTS (SELECT 1
                  FROM appointment
                  WHERE property_id = 'be4fb0db-9e5f-46f9-a82f-067d7a08a77a')
  AND NOT EXISTS (SELECT 1
                  FROM image
                  WHERE property_id = 'be4fb0db-9e5f-46f9-a82f-067d7a08a77a');
