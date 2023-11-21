SELECT property_id
FROM property_listing_for_rent;

SELECT property_id, dweller_email, score
FROM property_review;

-- NATURAL JOIN --> INNER JOIN
SELECT property_review.property_id, AVG(score) AS average_score, COUNT(*) AS review_count
FROM property_review
         JOIN property_listing_for_rent ON property_review.property_id = property_listing_for_rent.property_id
GROUP BY property_review.property_id
HAVING AVG(property_review.score) >= 4.0
   AND COUNT(*) >= 1
ORDER BY average_score DESC;

SELECT property_id, dweller_email, is_met
FROM appointment;

WITH dweller_appointment_count AS (SELECT dweller_email, COUNT(*) AS appointment_count
                                   FROM appointment
                                   WHERE is_met = FALSE
                                   GROUP BY dweller_email)
SELECT *
FROM dweller_appointment_count
WHERE appointment_count = (SELECT MAX(appointment_count)
                           FROM dweller_appointment_count)
ORDER BY dweller_email;