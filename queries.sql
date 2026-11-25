SELECT COUNT(*) FROM zomato_analysis.restaurants_full;
SELECT * FROM zomato_analysis.restaurants_full LIMIT 5;
SELECT COUNT(*) AS total_rows
FROM zomato_analysis.restaurants_full;

-- analysis 1: Which cities have the most restaurants?
SELECT city, COUNT(*) AS restaurant_count
FROM zomato_analysis.restaurants_full
GROUP BY city
ORDER BY restaurant_count DESC
LIMIT 10;

-- Analysis 2: Most common cuisine combinations
SELECT cuisines, COUNT(*) AS restaurant_count
FROM zomato_analysis.restaurants_full
WHERE cuisines IS NOT NULL
GROUP BY cuisines
ORDER BY restaurant_count DESC
LIMIT 10;

-- Analysis 3: Finf the average rating by city
SELECT city,
       ROUND(AVG(aggregate_rating), 2) AS average_rating,
       COUNT(*) AS restaurant_count
FROM zomato_analysis.restaurants_full
WHERE aggregate_rating IS NOT NULL
GROUP BY city
HAVING COUNT(*) >= 20
ORDER BY average_rating DESC
LIMIT 10;

-- Analysis 4: How many restaurants offer online
SELECT has_online_delivery,
       COUNT(*) AS restaurant_count
FROM zomato_analysis.restaurants_full
GROUP BY has_online_delivery
ORDER BY restaurant_count DESC;

-- Analysis 5: Compare average ratings for restaurants with and without online delivery.
SELECT has_online_delivery,
       COUNT(*) AS restaurant_count,
       ROUND(AVG(aggregate_rating), 2) AS average_rating
FROM zomato_analysis.restaurants_full
WHERE aggregate_rating IS NOT NULL
GROUP BY has_online_delivery;

-- Analysis 6: Find the top 10 restaurants by rating
SELECT `restaurant_name`,
       city,
       aggregate_rating,
       votes
FROM zomato_analysis.restaurants_full
WHERE aggregate_rating IS NOT NULL
ORDER BY aggregate_rating DESC, votes DESC
LIMIT 10;

-- Analysis 7: Compare restaurants by price range
SELECT price_range,
       COUNT(*) AS restaurant_count,
       ROUND(AVG(aggregate_rating), 2) AS average_rating,
       ROUND(AVG(average_cost_for_two), 0) AS avg_cost_for_two
FROM zomato_analysis.restaurants_full
WHERE aggregate_rating IS NOT NULL
GROUP BY price_range
ORDER BY price_range;

-- Analysis 8: Compare ratings for restaurants with and without table booking.
SELECT has_table_booking,
       COUNT(*) AS restaurant_count,
       ROUND(AVG(aggregate_rating), 2) AS average_rating
FROM zomato_analysis.restaurants_full
WHERE aggregate_rating IS NOT NULL
GROUP BY has_table_booking;

-- Analysis 9: Find the most expensive restaurants by average cost for two
SELECT restaurant_name,
       city,
       currency,
       average_cost_for_two,
       aggregate_rating
FROM zomato_analysis.restaurants_full
WHERE average_cost_for_two IS NOT NULL
ORDER BY average_cost_for_two DESC
LIMIT 10;

-- Analysis 10: See the distribution of restaurant ratings.
SELECT aggregate_rating,
       COUNT(*) AS restaurant_count
FROM zomato_analysis.restaurants_full
GROUP BY aggregate_rating
ORDER BY aggregate_rating;

-- Analysis 11: Count restaurants by rating category
SELECT rating_text,
       COUNT(*) AS restaurant_count
FROM zomato_analysis.restaurants_full
GROUP BY rating_text
ORDER BY restaurant_count DESC;

-- Analysis 12: Average rating by country
SELECT country_code,
       COUNT(*) AS restaurant_count,
       ROUND(AVG(NULLIF(aggregate_rating, 0)), 2) AS average_rating
FROM zomato_analysis.restaurants_full
GROUP BY country_code
HAVING COUNT(NULLIF(aggregate_rating, 0)) >= 20
ORDER BY average_rating DESC;

-- Analysis 13: Find cities with the highest average rating among cities with at least 100 rated restaurants
SELECT city,
       COUNT(*) AS rated_restaurants,
       ROUND(AVG(NULLIF(aggregate_rating, 0)), 2) AS average_rating
FROM zomato_analysis.restaurants_full
GROUP BY city
HAVING COUNT(NULLIF(aggregate_rating, 0)) >= 100
ORDER BY average_rating DESC
LIMIT 10;

-- Analysis 14: Count restaurants by table-booking and online-delivery availability.
SELECT has_table_booking,
       has_online_delivery,
       COUNT(*) AS restaurant_count
FROM zomato_analysis.restaurants_full
GROUP BY has_table_booking, has_online_delivery
ORDER BY has_table_booking, has_online_delivery;

-- Analysis 15: Online delivery availability by price range.
SELECT price_range,
       has_online_delivery,
       COUNT(*) AS restaurant_count
FROM zomato_analysis.restaurants_full
GROUP BY price_range, has_online_delivery
ORDER BY price_range, has_online_delivery;

-- Analysis 16: Calculate the online-delivery percentage for each price range
SELECT price_range,
       COUNT(*) AS total_restaurants,
       SUM(CASE WHEN has_online_delivery = 'Yes' THEN 1 ELSE 0 END)
           AS delivery_restaurants,
       ROUND(
           100.0 * SUM(CASE WHEN has_online_delivery = 'Yes' THEN 1 ELSE 0 END)
           / COUNT(*),
           1
       ) AS delivery_percentage
FROM zomato_analysis.restaurants_full
GROUP BY price_range
ORDER BY price_range;

-- Analysis 17: Average rating by cuisine
SELECT
    cuisines,
    COUNT(NULLIF(aggregate_rating, 0)) AS rated_restaurants,
    ROUND(AVG(NULLIF(aggregate_rating, 0)), 2) AS average_rating
FROM zomato_analysis.restaurants_full
WHERE cuisines IS NOT NULL
GROUP BY cuisines
HAVING COUNT(NULLIF(aggregate_rating, 0)) >= 100
ORDER BY average_rating DESC
LIMIT 10;

-- Analysis 18: Online delivery by city
SELECT
    city,
    COUNT(*) AS total_restaurants,
    SUM(CASE WHEN has_online_delivery = 'Yes' THEN 1 ELSE 0 END)
        AS delivery_restaurants,
    ROUND(
        100.0 * SUM(CASE WHEN has_online_delivery = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        1
    ) AS delivery_percentage
FROM zomato_analysis.restaurants_full
WHERE city IS NOT NULL
GROUP BY city
HAVING COUNT(*) >= 100
ORDER BY delivery_percentage DESC
LIMIT 10;

-- Analysis 19: Do restaurants with more votes have higher ratings?
SELECT
    CASE
        WHEN votes = 0 THEN '0 votes'
        WHEN votes BETWEEN 1 AND 100 THEN '1-100 votes'
        WHEN votes BETWEEN 101 AND 500 THEN '101-500 votes'
        ELSE 'More than 500 votes'
    END AS vote_group,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(NULLIF(aggregate_rating, 0)), 2) AS average_rating
FROM zomato_analysis.restaurants_full
GROUP BY vote_group
ORDER BY
    CASE vote_group
        WHEN '0 votes' THEN 1
        WHEN '1-100 votes' THEN 2
        WHEN '101-500 votes' THEN 3
        ELSE 4
    END;
    -- Analysis 20: Most popular restaurants by votes
    SELECT
    restaurant_name,
    city,
    votes,
    aggregate_rating
FROM zomato_analysis.restaurants_full
WHERE votes > 0
ORDER BY votes DESC
LIMIT 10;

-- Analysis 21: Which cuisine entries have the most online delivery?
SELECT
    cuisines,
    COUNT(*) AS total_restaurants,
    SUM(CASE WHEN has_online_delivery = 'Yes' THEN 1 ELSE 0 END)
        AS delivery_restaurants,
    ROUND(
        100.0 * SUM(CASE WHEN has_online_delivery = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        1
    ) AS delivery_percentage
FROM zomato_analysis.restaurants_full
WHERE cuisines IS NOT NULL
GROUP BY cuisines
HAVING COUNT(*) >= 100
ORDER BY delivery_percentage DESC
LIMIT 10;

-- Analysis 22: Average cost by online delivery
SELECT
    has_online_delivery,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(average_cost_for_two), 0) AS average_cost_for_two
FROM zomato_analysis.restaurants_full
GROUP BY has_online_delivery;

-- Analysis 23: Compare average ratings by price range and delivery
SELECT
    price_range,
    has_online_delivery,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(NULLIF(aggregate_rating, 0)), 2) AS average_rating
FROM zomato_analysis.restaurants_full
GROUP BY price_range, has_online_delivery
ORDER BY price_range, has_online_delivery;

-- Analysis 24: Top cities by average rating
SELECT
    city,
    COUNT(NULLIF(aggregate_rating, 0)) AS rated_restaurants,
    ROUND(AVG(NULLIF(aggregate_rating, 0)), 2) AS average_rating
FROM zomato_analysis.restaurants_full
WHERE city IS NOT NULL
GROUP BY city
HAVING COUNT(NULLIF(aggregate_rating, 0)) >= 100
ORDER BY average_rating DESC
LIMIT 10;

-- Analysis 25: Highest-rated restaurants with substantial votes
SELECT
    restaurant_name,
    city,
    aggregate_rating,
    votes
FROM zomato_analysis.restaurants_full
WHERE aggregate_rating >= 4.5
  AND votes >= 1000
ORDER BY aggregate_rating DESC, votes DESC
LIMIT 10;
-- Analysis 26: Overall dataset summary
SELECT
    COUNT(*) AS total_restaurants,
    COUNT(NULLIF(aggregate_rating, 0)) AS rated_restaurants,
    SUM(CASE WHEN aggregate_rating = 0 THEN 1 ELSE 0 END) AS unrated_restaurants,
    ROUND(AVG(NULLIF(aggregate_rating, 0)), 2) AS overall_average_rating
FROM zomato_analysis.restaurants_full;