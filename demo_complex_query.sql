SELECT property_id
FROM property_listing_for_rent;

SELECT property_id, dweller_email, score
FROM property_review;

-- NATURAL JOIN --> INNER JOIN

SELECT property_id, dweller_email, is_met
FROM appointment;

WITH dweller_appointment_count AS (SELECT dweller_email, COUNT(dweller_email) AS appointment_count
                                   FROM appointment
                                   WHERE is_met = FALSE
                                   GROUP BY dweller_email)
SELECT *
FROM dweller_appointment_count
WHERE appointment_count = (SELECT MAX(appointment_count)
                           FROM dweller_appointment_count)
ORDER BY dweller_email;