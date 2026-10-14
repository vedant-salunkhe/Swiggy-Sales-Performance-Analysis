-- Swiggy Sales & Performance Analysis
-- 04.Data Validation
-- Oracle SQL

-- Record counts
SELECT COUNT(*) AS raw_records
FROM swiggy_t;

SELECT COUNT(*) AS fact_records
FROM f_swiggy_orders;

-- Dimension counts
SELECT COUNT(*) AS date_records FROM d_date;
SELECT COUNT(*) AS location_records FROM d_location;
SELECT COUNT(*) AS restaurant_records FROM d_restaurant;
SELECT COUNT(*) AS category_records FROM d_category;
SELECT COUNT(*) AS dish_records FROM d_dish;

-- Fact-table completeness
SELECT
    COUNT(*) AS total_rows,
    COUNT(price) AS price_available,
    COUNT(rating) AS rating_available,
    COUNT(rating_count) AS rating_count_available
FROM f_swiggy_orders;

-- Check duplicate fact IDs
SELECT
    order_id,
    COUNT(*) AS record_count
FROM f_swiggy_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Compare unique dish counts across source, dimension and fact
SELECT COUNT(DISTINCT dish_name) AS total_dishes
FROM swiggy_t;

SELECT COUNT(DISTINCT dish_name) AS total_dishes
FROM d_dish;

SELECT COUNT(DISTINCT dish_id) AS total_dishes
FROM f_swiggy_orders;

-- Check that every dish dimension record has a matching fact record
SELECT COUNT(*) AS missing_dishes
FROM d_dish d
WHERE NOT EXISTS (
    SELECT 1 FROM f_swiggy_orders f
    WHERE f.dish_id = d.dish_id
);

-- Compare restaurant counts
SELECT COUNT(DISTINCT restaurant_name) AS total_restaurants
FROM swiggy_t;

SELECT COUNT(DISTINCT restaurant_name) AS total_restaurants
FROM d_restaurant;

-- Check case-sensitive restaurant-name variants
SELECT * FROM d_restaurant
WHERE restaurant_name IN ('7Th Heaven', '7th Heaven');





