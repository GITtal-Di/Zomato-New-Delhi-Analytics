-- ============================================================
-- Zomato New Delhi Restaurant Analytics
-- PostgreSQL Analysis Queries
-- ============================================================
--
-- Dataset table: restaurants
-- Primary scope: New Delhi
-- Q4-Q6 intentionally use the complete dataset.
--
-- ============================================================

-- Q0. Dwarka Data Availability
-- --------------------------------------------------------------------
SELECT
    "Locality",
    "Locality Verbose",
    COUNT(*) AS restaurant_count
FROM restaurants
WHERE "City" = 'New Delhi'
  AND (
      "Locality" ILIKE '%Dwarka%'
      OR "Locality Verbose" ILIKE '%Dwarka%'
  )
GROUP BY
    "Locality",
    "Locality Verbose"
ORDER BY restaurant_count DESC;

-- Q1. Highly Rated Restaurants with Online Delivery
-- --------------------------------------------------------------------
SELECT
    "Restaurant Name",
    "Locality",
    "Cuisines",
    "Aggregate rating",
    "Votes",
    "Average Cost for two"
FROM restaurants
WHERE "City" = 'New Delhi'
  AND "Aggregate rating" > 0
  AND "Has Online delivery" = 'Yes'
ORDER BY
    "Aggregate rating" DESC,
    "Votes" DESC
LIMIT 20;

-- Q2. Value Score
-- --------------------------------------------------------------------
SELECT
    "Restaurant Name",
    "Locality",
    "Cuisines",
    "Aggregate rating",
    "Average Cost for two",
    "Votes",

    ROUND(
        ((
            "Aggregate rating"
            / NULLIF("Average Cost for two", 0)
        ) * 100)::numeric,
        2
    ) AS value_score

FROM restaurants

WHERE "City" = 'New Delhi'
  AND "Aggregate rating" > 0
  AND "Average Cost for two" > 0

ORDER BY value_score DESC
LIMIT 20;

-- Q3. New Delhi Locality Hotspots
-- --------------------------------------------------------------------
SELECT
    "Locality",
    COUNT(*) AS top_restaurant_count,

    ROUND(
        AVG("Aggregate rating")::numeric,
        2
    ) AS average_rating,

    ROUND(
        AVG("Votes")::numeric,
        0
    ) AS average_votes

FROM restaurants

WHERE "City" = 'New Delhi'
  AND "Aggregate rating" >= 4.0

GROUP BY "Locality"

HAVING COUNT(*) >= 5

ORDER BY
    top_restaurant_count DESC,
    average_rating DESC

LIMIT 15;

-- Q4. Cuisine Diversity by Locality
-- --------------------------------------------------------------------
SELECT
    "Locality",
    COUNT(DISTINCT "Cuisines") AS distinct_cuisine_count
FROM restaurants
GROUP BY "Locality"
ORDER BY distinct_cuisine_count DESC
LIMIT 10;

-- Q5. Cost Segmentation
-- --------------------------------------------------------------------
SELECT
    CASE
        WHEN "Average Cost for two" <= 300
            THEN 'Budget (<= 300)'

        WHEN "Average Cost for two" <= 700
            THEN 'Mid-Range (301-700)'

        WHEN "Average Cost for two" <= 1500
            THEN 'Premium (701-1500)'

        ELSE 'Luxury (> 1500)'
    END AS cost_bucket,

    COUNT(*) AS restaurant_count,

    ROUND(
        AVG("Aggregate rating")::numeric,
        2
    ) AS average_rating,

    ROUND(
        AVG("Votes")::numeric,
        0
    ) AS average_votes

FROM restaurants

WHERE "Aggregate rating" > 0
  AND "Average Cost for two" > 0

GROUP BY cost_bucket

ORDER BY
    average_rating DESC;

-- Q6. Online Delivery & Table Booking Association
-- --------------------------------------------------------------------
SELECT
    "Has Online delivery",
    "Has Table booking",

    COUNT(*) AS restaurant_count,

    ROUND(
        AVG("Aggregate rating")::numeric,
        2
    ) AS average_rating,

    ROUND(
        AVG("Votes")::numeric,
        0
    ) AS average_votes

FROM restaurants

WHERE "Aggregate rating" > 0

GROUP BY
    "Has Online delivery",
    "Has Table booking"

ORDER BY average_rating DESC;

-- Q7. Most Expensive Cuisine Combinations
-- --------------------------------------------------------------------
SELECT
    "Cuisines",

    COUNT(*) AS restaurant_count,

    ROUND(
        AVG("Average Cost for two")::numeric,
        2
    ) AS average_cost,

    ROUND(
        AVG("Aggregate rating")::numeric,
        2
    ) AS average_rating

FROM restaurants

WHERE "City" = 'New Delhi'
  AND "Average Cost for two" > 0

GROUP BY "Cuisines"

HAVING COUNT(*) >= 5

ORDER BY average_cost DESC

LIMIT 15;

-- Q8. Highest-Rated New Delhi Localities
-- --------------------------------------------------------------------
SELECT
    "Locality",

    COUNT(*) AS restaurant_count,

    ROUND(
        AVG("Aggregate rating")::numeric,
        2
    ) AS average_rating,

    SUM("Votes") AS total_votes,

    ROUND(
        AVG("Votes")::numeric,
        0
    ) AS average_votes

FROM restaurants

WHERE "City" = 'New Delhi'
  AND "Aggregate rating" > 0

GROUP BY "Locality"

HAVING COUNT(*) >= 5

ORDER BY
    average_rating DESC,
    total_votes DESC

LIMIT 15;

-- Q9. Top 3 Restaurants per Locality
-- --------------------------------------------------------------------
WITH ranked_restaurants AS (
    SELECT
        "Restaurant Name",
        "Locality",
        "Aggregate rating",
        "Votes",
        "Average Cost for two",

        RANK() OVER (
            PARTITION BY "Locality"
            ORDER BY
                "Aggregate rating" DESC,
                "Votes" DESC
        ) AS locality_rank

    FROM restaurants

    WHERE "City" = 'New Delhi'
      AND "Aggregate rating" > 0
)

SELECT *
FROM ranked_restaurants
WHERE locality_rank <= 3
ORDER BY "Locality", locality_rank;

-- Q10. Most Popular New Delhi Restaurants
-- --------------------------------------------------------------------
SELECT
    "Restaurant Name",
    "Locality",
    "Aggregate rating",
    "Votes",
    "Cuisines",
    "Average Cost for two"

FROM restaurants

WHERE "City" = 'New Delhi'
  AND "Votes" > 0

ORDER BY "Votes" DESC
LIMIT 20;

-- Q11. High-Rated Restaurants with Below-Median Votes
-- --------------------------------------------------------------------
WITH median_votes AS (
    SELECT
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY "Votes") AS median_vote_count
    FROM restaurants
    WHERE "City" = 'New Delhi'
)

SELECT
    r."Restaurant Name",
    r."Locality",
    r."Aggregate rating",
    r."Votes",
    r."Cuisines",
    r."Average Cost for two"

FROM restaurants r
CROSS JOIN median_votes m

WHERE r."City" = 'New Delhi'
  AND r."Aggregate rating" >= 4.0
  AND r."Votes" < m.median_vote_count
  AND r."Votes" > 0

ORDER BY
    r."Aggregate rating" DESC,
    r."Votes" ASC

LIMIT 20;

-- Q12. Locality Engagement
-- --------------------------------------------------------------------
SELECT
    "Locality",

    COUNT(*) AS restaurant_count,

    ROUND(
        AVG("Aggregate rating")::numeric,
        2
    ) AS average_rating,

    SUM("Votes") AS total_votes,

    ROUND(
        AVG("Votes")::numeric,
        0
    ) AS average_votes

FROM restaurants

WHERE "City" = 'New Delhi'
  AND "Aggregate rating" > 0

GROUP BY "Locality"

HAVING COUNT(*) >= 10

ORDER BY average_votes DESC

LIMIT 15;

-- Q13. Restaurant vs. Locality Benchmark
-- --------------------------------------------------------------------
WITH locality_stats AS (
    SELECT
        "Locality",
        AVG("Aggregate rating") AS locality_avg_rating
    FROM restaurants
    WHERE "City" = 'New Delhi'
      AND "Aggregate rating" > 0
    GROUP BY "Locality"
)

SELECT
    r."Restaurant Name",
    r."Locality",
    r."Aggregate rating",

    ROUND(
        ls.locality_avg_rating::numeric,
        2
    ) AS locality_avg_rating,

    ROUND(
        (r."Aggregate rating" - ls.locality_avg_rating)::numeric,
        2
    ) AS rating_vs_locality

FROM restaurants r

JOIN locality_stats ls
    ON r."Locality" = ls."Locality"

WHERE r."City" = 'New Delhi'
  AND r."Aggregate rating" > 0

ORDER BY rating_vs_locality DESC

LIMIT 20;

-- Q14. Weighted Restaurant Rating
-- --------------------------------------------------------------------
WITH rating_stats AS (
    SELECT
        AVG("Aggregate rating") AS overall_avg_rating,
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY "Votes") AS min_votes
    FROM restaurants
    WHERE "City" = 'New Delhi'
      AND "Aggregate rating" > 0
      AND "Votes" > 0
),

weighted_restaurants AS (
    SELECT
        r."Restaurant Name",
        r."Locality",
        r."Cuisines",
        r."Aggregate rating",
        r."Votes",
        r."Average Cost for two",

        ROUND(
            (
                (
                    r."Votes"::numeric
                    / (r."Votes" + s.min_votes)
                ) * r."Aggregate rating"
                +
                (
                    s.min_votes
                    / (r."Votes" + s.min_votes)
                ) * s.overall_avg_rating
            )::numeric,
            3
        ) AS weighted_rating

    FROM restaurants r
    CROSS JOIN rating_stats s

    WHERE r."City" = 'New Delhi'
      AND r."Aggregate rating" > 0
      AND r."Votes" > 0
)

SELECT
    "Restaurant Name",
    "Locality",
    "Cuisines",
    "Aggregate rating",
    "Votes",
    "Average Cost for two",
    weighted_rating
FROM weighted_restaurants
ORDER BY weighted_rating DESC
LIMIT 20;

