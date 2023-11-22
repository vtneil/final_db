SELECT property_id
FROM property_listing_for_rent;

SELECT property_id, dweller_email, score
FROM property_review;

-- Query 1
SELECT property_review.property_id, AVG(score) AS average_score, COUNT(*) AS review_count
FROM property_review
         JOIN property_listing_for_rent ON property_review.property_id = property_listing_for_rent.property_id
GROUP BY property_review.property_id
HAVING AVG(property_review.score) >= 4.0
   AND COUNT(*) >= 1
ORDER BY average_score DESC;

SELECT property_id, dweller_email, is_met
FROM appointment;

-- Query 2
WITH dweller_appointment_count AS (SELECT dweller_email, COUNT(*) AS appointment_count
                                   FROM appointment
                                   WHERE is_met = FALSE
                                   GROUP BY dweller_email)
SELECT *
FROM dweller_appointment_count
WHERE appointment_count = (SELECT MAX(appointment_count)
                           FROM dweller_appointment_count)
ORDER BY dweller_email;

-- Query 3
WITH p_rent_count AS (SELECT r.property_id,
                             COUNT(*) AS property_rent_count
                      FROM "rent" r
                               JOIN
                           "transaction" t ON r.transaction_id = t.transaction_id
                      WHERE t.is_released = TRUE
                      GROUP BY r.property_id),
     o_p_rent_count AS (SELECT pl.owner_email
                             , prc.property_id
                             , prc.property_rent_count
                        FROM "property_listing" pl
                                 NATURAL JOIN
                             p_rent_count prc),
     o_rent_count AS (SELECT opc.owner_email
                           , SUM(opc.property_rent_count) AS owner_rent_count
                      FROM o_p_rent_count opc
                      GROUP BY opc.owner_email
                      ORDER BY SUM(opc.property_rent_count) DESC
                      LIMIT 10)
SELECT *
FROM o_rent_count;
