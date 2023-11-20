-- Insert
INSERT INTO admin (admin_id, admin_fname, admin_lname, admin_phone)
SELECT 'be4fb0db-9e5f-46f9-a82f-067d7a08a77b', 'John2', 'Doe2', '+1234567890';

-- Insert a new admin if they don't exist already
INSERT INTO admin (admin_id, admin_fname, admin_lname, admin_phone)
SELECT 'be4fb0db-9e5f-46f9-a82f-067d7a08a77b', 'John2', 'Doe2', '+1234567890'
WHERE NOT EXISTS (SELECT 1
                  FROM admin
                  WHERE admin_phone = '+1234567891');

-- Update
UPDATE property_review
    SET score = 99
WHERE
    property_id = '702e7e08-9635-4b13-ae37-3de43c82fc83';

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
